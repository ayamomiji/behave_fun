module BehaveFun
  class Decorators::UntilSuccess < Decorator
    def child_success
      success
    end

    add_to_task_builder
  end
end
