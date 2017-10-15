module CapacityKeeper::Plugins
  class SimpleCounter < CapacityKeeper::Plugin

    config :max, 10

    @@counter = 0

    # @override
    #
    # @return [Boolean] if counter exceeds maximum then false
    def performable?
      @@counter <= configs[:max]
    end

    # @return [Integer] current counter value
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
