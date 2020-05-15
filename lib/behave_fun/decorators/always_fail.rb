module BehaveFun
  class Decorators::AlwaysFail < Decorator
    def child_success
      fail
    end

    add_to_task_builder
  end
end
