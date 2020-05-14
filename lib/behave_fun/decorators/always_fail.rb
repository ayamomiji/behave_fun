module BehaveFun
  class Decorators::AlwaysFail < Decorator
    def child_success
      fail
    end
  end
end
