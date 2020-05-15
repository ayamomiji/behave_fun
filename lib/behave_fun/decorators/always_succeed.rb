module BehaveFun
  class Decorators::AlwaysSucceed < Decorator
    def child_fail
      success
    end

    add_to_task_builder
  end
end
