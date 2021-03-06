module BehaveFun
  class BranchTasks::DynamicGuardSelector < Task
    def execute
      child = @children.find { _1.guard_passed? }
      if @current_child != child
        @current_child.cancel if @current_child
        @current_child = child
        @current_child.reset
      end
      @current_child.run
    end

    def start
      super
      @current_child = nil
    end

    def child_running
      running
    end

    def child_success
      success
    end

    def child_fail
      fail
    end
  end
end
