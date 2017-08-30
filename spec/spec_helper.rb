$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'capacity_keeper'

require 'pry'

class ExampleKeeper < CapacityKeeper::Plugin

  config :default_is_nil
  config :reservable_str, "test"

  @@state = "test"

  # @override
  def reservable?
    @@state == configs[:reservable_str]
  end

  # @override
  def deposit
    @@state = "deposit"
  end

  # @override
  def reposit
    @@state = configs[:reservable_str]
  end
end

class OtherKeeper < CapacityKeeper::Plugin

  config :default_is_nil
  config :reservable_str, "test"

  @@state = "test"

  # @override
  def reservable?
    @@state == configs[:reservable_str]
  end

  # @override
  def deposit
    @@state = "deposit"
  end

  # @override
  def reposit
    @@state = configs[:reservable_str]
  end
end
