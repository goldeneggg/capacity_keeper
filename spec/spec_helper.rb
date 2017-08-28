$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'capacity_keeper'

require 'pry'

class ExampleKeeper < CapacityKeeper::Plugin

  config :default_is_nil
  config :satisfied_str, "test"

  @@state = "test"

  # @override
  def satisfied?
    @@state == configs[:satisfied_str]
  end

  # @override
  def reduce_capacity
    @@state = "reduce_capacity"
  end

  # @override
  def gain_capacity
    @@state = configs[:satisfied_str]
  end
end

class OtherKeeper < CapacityKeeper::Plugin

  config :default_is_nil
  config :satisfied_str, "test"

  @@state = "test"

  # @override
  def satisfied?
    @@state == configs[:satisfied_str]
  end

  # @override
  def reduce_capacity
    @@state = "reduce_capacity"
  end

  # @override
  def gain_capacity
    @@state = configs[:satisfied_str]
  end
end
