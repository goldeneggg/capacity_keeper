require 'logger'

module CapacityKeeper
  module Config
    extend self

    attr_writer :retry_count

    def retry_count
      @retry_count ||= 5
    end

    attr_writer :retry_interval_second

    def retry_interval_second
      @retry_interval_second ||= 5
    end

    attr_writer :raise_on_retry_fail

    def raise_on_retry_fail
      @raise_on_retry_fail ||= false
    end

    attr_writer :logger

    def logger
      @logger ||= ::Logger.new(STDOUT)
    end

    attr_writer :verbose

    def verbose
      @verbose ||= false
    end
  end
end
