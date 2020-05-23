module BehaveFun
  class BranchTasks::Selector < Task
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
      success
    end

    def child_fail
      @current_child_idx += 1
      if @current_child_idx >= children.size
        fail
      else
        run
      end
    end

    def serializable_status_fields
      [:current_child_idx]
    end
  end
end
