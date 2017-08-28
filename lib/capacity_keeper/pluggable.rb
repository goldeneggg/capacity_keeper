module CapacityKeeper
  module Pluggable
    include CapacityKeeper::Errors

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def configs
        return @configs if instance_variable_defined?(:@configs)

        @configs = if superclass.respond_to?(:configs)
          superclass.configs
        else
          {}
        end

        @configs[:retry_count] ||= Config.retry_count
        @configs[:retry_sleep_second] ||= Config.retry_sleep_second
        @configs[:raise_on_retry_fail] ||= Config.raise_on_retry_fail
        @configs[:logger] ||= Config.logger
        @configs[:verbose] ||= Config.verbose

        @configs
      end

      def config(name, default_value = nil)
        configs[name] = default_value
      end
    end

    def name
      self.class.name
    end

    def configs
      @configs ||= self.class.configs.dup
    end

    def retry_count
      configs[:retry_count]
    end

    def retry_sleep_second
      configs[:retry_sleep_second]
    end

    def raise_on_retry_fail?
      configs[:raise_on_retry_fail] == true
    end

    def log_verbose(msg)
      logger.info("#{name}: #{msg}") if !logger.nil? && verbose?
    end

    def logger
      configs[:logger]
    end

    def verbose?
      configs[:verbose] == true
    end

    private

    def merge_configs(opts = {})
      opts.each { |k, v| configs[k] = v if configs.keys.include?(k) }
    end
  end
end
