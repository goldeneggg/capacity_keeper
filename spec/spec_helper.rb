$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'capacity_keeper'

require 'pry'

class DefaultConfigKeeper < CapacityKeeper::Plugin

  config :performable_str, "test"

  @@state = "test"

  # @override
  def performable?
    runtime_state = @opts[:performable_str] || configs[:performable_str]
    @@state == runtime_state
  end

  # @override
  def lock
    @@state = "lock"
  end

  # @override
  def unlock
    @@state = configs[:performable_str]
  end
end

class OtherKeeper < CapacityKeeper::Plugin

  retry_count 10
  retry_interval_second 10
  raise_on_retry_fail true
  verbose true

  config :performable_str, "test"
  config :test_val, 20

  @@state = "test"

  # @override
  def performable?
    runtime_state = @opts[:performable_str] || configs[:performable_str]
    @@state == runtime_state
  end

  # @override
  def lock
    @@state = "lock"
  end

  # @override
  def unlock
    @@state = configs[:performable_str]
  end
end
