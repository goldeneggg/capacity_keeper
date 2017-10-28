require "capacity_keeper/version"
require 'capacity_keeper/errors'
require 'capacity_keeper/config'
require 'capacity_keeper/pluggable'
require 'capacity_keeper/plugin'
require 'capacity_keeper/plugins/simple_counter'

module CapacityKeeper

  def self.configure
    yield Config
  end

  # @param [Class] plugin plugin class
  # @param [Hash] opts runtime options
  # @return [CapacityKeeper::Keepers]
  def within_capacity(plugin: nil, opts: {}, &block)
    keepers = Keepers.new(opts)
    keepers.add_plugin(plugin) unless plugin.nil?

    return keepers.perform(&block) if block_given?

    keepers
  end

  class Keepers
    def initialize(opts = {})
      @plugins = []
      @opts = opts
    end

    # @param [Class] plugin plugin class
    def add_plugin(plugin, &block)
      @plugins << plugin.new(opts: @opts)

      return perform(&block) if block_given?

      self
    end

    # @return [Object] some return object from assigned block
    def perform
      wait_retry

      begin
        @plugins.each do |plugin|
          plugin.before
          plugin.log_verbose("do before")
        end
        yield
      ensure
        @plugins.each do |plugin|
          begin
            plugin.after
            plugin.log_verbose("do after")
          rescue => ex
            plugin.log_verbose("failed to do after. exception:#{ex.class.name}, message:#{ex.message}")
          end
        end
      end
    end

    private

    def wait_retry
      @plugins.each do |plugin|
        plugin.log_verbose("start wait_retry of plugin:#{plugin.name}")

        performable = false
        plugin.retry_count.times do
          if plugin.performable?
            performable = true
            plugin.log_verbose("ok performable")
            break
          end
          plugin.log_verbose("sleep for #{plugin.retry_interval_second} second from now on")
          sleep(plugin.retry_interval_second)
        end
        plugin.log_verbose("break retry loop. performable=#{performable}")
        next if performable

        if plugin.raise_on_retry_fail?
          raise ::CapacityKeeper::Errors::OverRetryLimitError.new("#{plugin.name}: failed to capacity check")
        end
      end
    end
  end
end
