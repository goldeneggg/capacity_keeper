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
    def before
      lock
      @locked = true
    end

    # after block execution
    def after
      unlock if @locked
    end

    private

    # execute lock in before execution
    def lock
      raise NotImplementedError.new("must be override")
    end

    # execute unlock in after execution
    def unlock
      raise NotImplementedError.new("must be override")
    end
  end
end
