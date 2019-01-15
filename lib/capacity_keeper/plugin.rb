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
      @beginning = true
      begin_process
    end

    # after block execution
    def after
      if beginning?
        @beginning = false
        finish_process
      end
    end

    def beginning?
      @beginning || false
    end

    private

    # begin assigned block
    def begin_process
      raise NotImplementedError.new("must be override")
    end

    # finish assigned block
    def finish_process
      raise NotImplementedError.new("must be override")
    end
  end
end
