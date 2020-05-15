module BehaveFun
  class Decorators::UntilFail < Decorator
    def child_fail
      success
    end

    add_to_task_builder
  end
end
