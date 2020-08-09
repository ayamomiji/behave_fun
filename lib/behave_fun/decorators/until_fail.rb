module BehaveFun
  class Decorators::UntilFail < Decorator
    def child_success
      reset
      execute
    end

    def child_fail
      success
    end
  end
end
