require "capacity_keeper/version"
require 'capacity_keeper/errors'
require 'capacity_keeper/config'
require 'capacity_keeper/pluggable'
require 'capacity_keeper/plugin'
require 'capacity_keeper/plugin/simple_counter'

module CapacityKeeper
  include CapacityKeeper::Errors

  def self.configure
    yield Config
  end

  def with_capacity(keeper: nil, opts: {}, &block)
    keepers = Keepers.new(opts: opts)
    keepers.add_keeper(keeper: keeper) unless keeper.nil?

    return keepers.exec(&block) if block_given?

    keepers
  end

  class Keepers
    def initialize(opts: {})
      @keepers = []
      @opts = opts
    end

    def add_keeper(keeper:, &block)
      @keepers << keeper.new(opts: @opts)

      return exec(&block) if block_given?

      self
    end

    def exec
      wait_retry

      begin
        @keepers.each do |keeper|
          keeper.reduce_capacity
          keeper.log_verbose("complete reduce capacity")
        end
        yield
      ensure
        @keepers.each do |keeper|
          keeper.gain_capacity
          keeper.log_verbose("complete gain capacity")
        end
      end
    end

    private

    def wait_retry
      @keepers.each do |keeper|
        keeper.log_verbose("start wait_retry")

        satisfied = false
        keeper.retry_count.times do
          if keeper.satisfied?
            satisfied = true
            keeper.log_verbose("satisfied")
            break
          end
          keeper.log_verbose("sleep for #{keeper.retry_sleep_second} second")
          sleep(keeper.retry_sleep_second)
        end
        keeper.log_verbose("break retry loop")
        next if satisfied

        if keeper.raise_on_retry_fail?
          raise ::CapacityKeeper::Errors::OverRetryLimitError.new("#{keeper.name}: failed to capacity check")
        end

        keeper.log_verbose("end wait_retry")
      end
    end
  end
end
