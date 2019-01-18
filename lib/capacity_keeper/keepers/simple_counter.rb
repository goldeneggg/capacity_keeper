module CapacityKeeper::Keepers
  class SimpleCounter < CapacityKeeper::Keeper

    config :max, 10

    @@counter = 0

    # @override
    def performable?
      @@counter <= configs[:max]
    end

    def self.counter
      @@counter
    end

    private

    # @override
    def begin_process
      @@counter += 1
    end

    # @override
    def finish_process
      @@counter -= 1 if @@counter > 0
    end
  end
end
