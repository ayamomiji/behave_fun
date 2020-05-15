module BehaveFun
  class BranchTasks::RandomSelector < BranchTasks::Selector
    attr_accessor :order

    def execute
      @order = (0...@children.size).to_a.shuffle unless @order

      @children[@order[@current_child_idx]].run
    end

    def start
      super
      @order = nil
    end

    def serializable_status_fields
      [:current_child_idx, :order]
    end

    add_to_task_builder
  end
end
