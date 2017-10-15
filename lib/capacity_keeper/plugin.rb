module CapacityKeeper
  class Plugin
    include CapacityKeeper::Pluggable
    include CapacityKeeper::Errors

    # @param [Hash] some options
    def initialize(opts: {})
      @opts = opts
    end

    # @return [Boolegn] if block is executable, then return true
    def performable?
      raise NotImplementedError.new("must be override")
    end

    # before block execution
    #
    # @return [Object] result of begin_process method
    def before
      @beginning = true
      begin_process
    end

    # after block execution
    #
    # @return [Object] if beginning? then result of finish_process method, else nil
    def after
      if beginning?
        @beginning = false
        finish_process
      end
    end

    # @return [Boolegn] if before was called and after is not called, then return true
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
