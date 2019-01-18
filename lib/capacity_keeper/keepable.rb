module CapacityKeeper
  module Keepable
    include ::CapacityKeeper::Errors

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def configs
        return @configs[self.name] if instance_variable_defined?(:@configs) && @configs.key?(self.name)

        @configs = {} unless @configs.is_a?(Hash)
        @configs[self.name] = {}
        @configs[self.name]
      end

      def config(name, default_value = nil)
        configs[name] = default_value
      end

      def retry_count(retry_count)
        config(:retry_count, retry_count)
      end

      def retry_interval_second(retry_interval_second)
        config(:retry_interval_second, retry_interval_second)
      end

      def raise_on_retry_fail(raise_on_retry_fail)
        config(:raise_on_retry_fail, raise_on_retry_fail)
      end

      def logger(logger)
        config(:logger, logger)
      end

      def verbose(verbose)
        config(:verbose, verbose)
      end
    end

    def name
      self.class.name
    end

    def configs
      @configs ||= self.class.configs
    end

    def retry_count
      configs[:retry_count] ||= ::CapacityKeeper::Config.retry_count
    end

    def retry_interval_second
      configs[:retry_interval_second] ||= ::CapacityKeeper::Config.retry_interval_second
    end

    def raise_on_retry_fail?
      configs[:raise_on_retry_fail] ||= ::CapacityKeeper::Config.raise_on_retry_fail
    end

    def logger
      configs[:logger] ||= ::CapacityKeeper::Config.logger
    end

    def verbose?
      configs[:verbose] ||= ::CapacityKeeper::Config.verbose
    end

    def log_verbose(msg)
      logger.info("#{name}: #{msg}") if !logger.nil? && verbose?
    end
  end
end
