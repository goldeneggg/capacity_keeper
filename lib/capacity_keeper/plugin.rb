module CapacityKeeper
  class Plugin
    include CapacityKeeper::Pluggable
    include CapacityKeeper::Errors

    def initialize(opts: {})
      @opts = opts
      merge_configs(@opts)
    end

    def satisfied?
      raise NotImplementedError.new("must be override")
    end

    def reduce_capacity
      raise NotImplementedError.new("must be override")
    end

    def gain_capacity
      raise NotImplementedError.new("must be override")
    end
  end
end
