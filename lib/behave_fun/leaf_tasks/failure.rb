module BehaveFun
  class LeafTasks::Failure < Task
    def execute
      fail
    end

    add_to_task_builder
  end
end
