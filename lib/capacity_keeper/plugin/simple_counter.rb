module CapacityKeeper
  class Plugin
    class SimpleCounter < CapacityKeeper::Plugin

      config :max, 5

      @@counter = 0

      # @override
      def satisfied?
        puts "satisfied? opts:#{@opts.inspect}"
        @@counter <= configs[:max]
      end

      # @override
      def reduce_capacity
        @@counter += 1
      end

      # @override
      def gain_capacity
        @@counter -= 1 if @@counter > 0
      end
    end
  end
end
