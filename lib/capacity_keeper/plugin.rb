module CapacityKeeper
  class Plugin
    include CapacityKeeper::Pluggable
    include CapacityKeeper::Errors

    def initialize(opts: {})
      @opts = opts
      merge_configs(@opts)
    end

    # @return [Boolegn] if block is executable, then return true
    def reservable?
      raise NotImplementedError.new("must be override")
    end

    # before block execution
    def deposit
      raise NotImplementedError.new("must be override")
    end

    # after block execution
    def reposit
      raise NotImplementedError.new("must be override")
    end
  end
end
