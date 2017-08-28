module CapacityKeeper
  module Errors
    class CapacityKeeperError < StandardError; end
    class CapacityKeeperRuntimeError < RuntimeError; end

    class UndefinedOptionError < CapacityKeeperRuntimeError; end
    class NoBlockAssignedError < CapacityKeeperRuntimeError; end
    class OverRetryLimitError < CapacityKeeperRuntimeError; end
    class RequiredVariableNotAssignedError < CapacityKeeperRuntimeError; end
  end
end
