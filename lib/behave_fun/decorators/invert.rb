module BehaveFun
  class Decorators::Invert < Decorator
    def child_fail
      success
    end

    def child_success
      fail
    end

    add_to_task_builder
  end
end
