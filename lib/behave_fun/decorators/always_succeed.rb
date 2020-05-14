module BehaveFun
  class Decorators::AlwaysSucceed < Decorator
    def child_fail
      success
    end
  end
end
