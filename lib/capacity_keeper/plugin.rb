module CapacityKeeper
  class Plugin
    include CapacityKeeper::Pluggable
    include CapacityKeeper::Errors

    def initialize(opts: {})
      @opts = opts
    end

    # @return [Boolegn] if block is executable, then return true
    def performable?
      raise NotImplementedError.new("must be override")
    end

    # before block execution
    def lock
      raise NotImplementedError.new("must be override")
    end

    # after block execution
    def unlock
      raise NotImplementedError.new("must be override")
    end
  end
end
