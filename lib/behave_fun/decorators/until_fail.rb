module BehaveFun
  class Decorators::UntilFail < Decorator
    def child_fail
      success
    end
  end
end
