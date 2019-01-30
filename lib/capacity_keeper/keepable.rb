module CapacityKeeper
  module Keepable
    include ::CapacityKeeper::Errors

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def config
        return @config[self.name] if instance_variable_defined?(:@config) && @config.key?(self.name)

        @config = {} unless @config.is_a?(Hash)
        @config[self.name] = {}
        @config[self.name]
      end

      def set_config(name, default_value = nil)
        config[name] = default_value
      end

      def retry_count(retry_count)
        set_config(:retry_count, retry_count)
      end

      def retry_interval_second(retry_interval_second)
        set_config(:retry_interval_second, retry_interval_second)
      end

      def raise_on_retry_fail(raise_on_retry_fail)
        set_config(:raise_on_retry_fail, raise_on_retry_fail)
      end

      def logger(logger)
        set_config(:logger, logger)
      end

      def verbose(verbose)
        set_config(:verbose, verbose)
      end
    end

    def name
      self.class.name
    end

    def config
      @config ||= self.class.config
    end

    def retry_count
      config[:retry_count] ||= ::CapacityKeeper::Config.retry_count
    end

    def retry_interval_second
      config[:retry_interval_second] ||= ::CapacityKeeper::Config.retry_interval_second
    end

    def raise_on_retry_fail?
      config[:raise_on_retry_fail] ||= ::CapacityKeeper::Config.raise_on_retry_fail
    end

    def logger
      config[:logger] ||= ::CapacityKeeper::Config.logger
    end

    def verbose?
      config[:verbose] ||= ::CapacityKeeper::Config.verbose
    end

    def log_verbose(msg)
      logger.info("#{name}: #{msg}") if !logger.nil? && verbose?
    end
  end
end
