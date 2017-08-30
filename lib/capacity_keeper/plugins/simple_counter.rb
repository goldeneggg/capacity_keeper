module CapacityKeeper::Plugins
  class SimpleCounter < CapacityKeeper::Plugin

    config :max, 10

    @@counter = 0

    # @override
    def reservable?
      @@counter <= configs[:max]
    end

    # @override
    def deposit
      @@counter += 1
    end

    # @override
    def reposit
      @@counter -= 1 if @@counter > 0
    end
  end
end
