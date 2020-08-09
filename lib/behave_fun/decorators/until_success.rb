module BehaveFun
  class Decorators::UntilSuccess < Decorator
    def child_success
      success
    end

    def child_fail
      reset
      execute
    end
  end
end
