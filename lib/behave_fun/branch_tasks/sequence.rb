module BehaveFun
  class BranchTasks::Sequence < Task
    attr_accessor :current_child_idx

    def execute
      @children[@current_child_idx].run
    end

    def start
      super
      @current_child_idx = 0
    end

    def child_running
      running
    end

    def child_success
      @current_child_idx += 1
      if @current_child_idx >= children.size
        success
      else
        run
      end
    end

    def child_fail
      fail
    end

    def serializable_status_fields
      [:current_child_idx]
    end

    add_to_task_builder
  end
end
