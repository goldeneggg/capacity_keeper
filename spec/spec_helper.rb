$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'capacity_keeper'

require 'pry'

class DefaultConfigKeeper < CapacityKeeper::Keeper

  config :performable_str, "unlock"

  attr_reader :state

  def initialize(opts: {})
    super
    @state = 'unlock'
  end

  # @override
  def performable?
    runtime_state = @opts[:performable_str] || configs[:performable_str]
    @state == runtime_state
  end

  private

  # @override
  def begin_process
    @state = "lock"
  end

  # @override
  def finish_process
    @state = configs[:performable_str]
  end
end

class OtherKeeper < CapacityKeeper::Keeper

  retry_count 10
  retry_interval_second 10
  raise_on_retry_fail true
  verbose true

  config :performable_str, "unlock"
  config :test_val, 20

  attr_reader :state

  def initialize(opts: {})
    super
    @state = 'unlock'
  end

  # @override
  def performable?
    runtime_state = @opts[:performable_str] || configs[:performable_str]
    @state == runtime_state
  end

  private

  # @override
  def begin_process
    @state = "lock"
  end

  # @override
  def finish_process
    @state = configs[:performable_str]
  end
end
