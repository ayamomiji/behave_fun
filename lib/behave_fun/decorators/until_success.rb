module BehaveFun
  class Decorators::UntilSuccess < Decorator
    def child_success
      success
    end
  end
end
