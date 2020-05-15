module BehaveFun
  class LeafTasks::Success < Task
    def execute
      success
    end

    add_to_task_builder
  end
end
