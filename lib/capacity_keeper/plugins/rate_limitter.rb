module CapacityKeeper::Plugins
  # FIXME
  # sidekiqでrate limitを管理する。既存のライブラリを使えればbetter
  class RateLimitter < ::CapacityKeeper::Plugin

    config :threshold, 10

    # @override
    def performable?
      # FIXME
      # thresholdを超えていなければOK = true
    end

    private

    # @override
    def begin_process
      # FIXME
    end

    # @override
    def finish_process
      # FIXME
    end
  end
end
