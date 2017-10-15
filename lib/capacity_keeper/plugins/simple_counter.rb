module CapacityKeeper::Plugins
  class SimpleCounter < CapacityKeeper::Plugin

    config :max, 10

    @@counter = 0

    # @override
    def performable?
      @@counter <= configs[:max]
    end

    # @override
    def lock
      @@counter += 1
    end

    # @override
    def unlock
      @@counter -= 1 if @@counter > 0
    end

    def self.counter
      @@counter
    end
  end
end
