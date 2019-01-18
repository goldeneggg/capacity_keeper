require "capacity_keeper/version"
require 'capacity_keeper/errors'
require 'capacity_keeper/config'
require 'capacity_keeper/keepable'
require 'capacity_keeper/keeper'
require 'capacity_keeper/keepers/simple_counter'

module CapacityKeeper

  def self.configure
    yield Config
  end

  # @param [Class] keeper keeper class
  # @param [Hash] opts runtime options
  # @return [CapacityKeeper::KeeperList]
  def within_capacity(keeper: nil, opts: {}, &block)
    list = KeeperList.new(opts)
    list.add(keeper) unless keeper.nil?

    return list.perform(&block) if block_given?

    list
  end

  class KeeperList
    def initialize(opts = {})
      @list = []
      @opts = opts
    end

    # @param [Class] keeper keeper class
    # @return [Object] if block_given then some return object from assigned block, else self
    def add(keeper, &block)
      @list << keeper.new(opts: @opts)

      return perform(&block) if block_given?

      self
    end

    # @return [Object] some return object from assigned block
    def perform
      wait_retry

      begin
        @list.each do |keeper|
          keeper.before
          keeper.log_verbose("do before")
        end
        yield
      ensure
        @list.each do |keeper|
          begin
            keeper.after
            keeper.log_verbose("do after")
          rescue => ex
            keeper.log_verbose("failed to do after. exception:#{ex.class.name}, message:#{ex.message}")
          end
        end
      end
    end

    private

    def wait_retry
      @list.each do |keeper|
        keeper.log_verbose("start wait_retry of keeper:#{keeper.name}")

        performable = false
        keeper.retry_count.times do
          if keeper.performable?
            performable = true
            keeper.log_verbose("ok performable")
            break
          end

          keeper.log_verbose("sleep for #{keeper.retry_interval_second} second from now on")
          sleep(keeper.retry_interval_second)
        end

        keeper.log_verbose("break retry loop. performable=#{performable}")
        next if performable

        if keeper.raise_on_retry_fail?
          raise ::CapacityKeeper::Errors::OverRetryLimitError.new("#{keeper.name}: failed to capacity check")
        end
      end
    end
  end
end
