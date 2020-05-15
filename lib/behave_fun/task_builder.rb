module BehaveFun
  class TaskBuilder
    attr_reader :control

    def initialize(control)
      @control = control
    end

    def add_task(type, state: nil, **params, &block)
      task = type.new(**params)
      @control.add_child(task)

      if block
        builder = TaskBuilder.new(task)
        builder.instance_eval(&block)
      end
    end

    def guard_with(&block)
      builder = TaskBuilder.new(Tree.new)
      builder.instance_eval(&block)
      control.guard = builder.control.root
    end

    def build_from_hash(task_hash)
      type, params, guard_with, children =
        task_hash.values_at(:type, :params, :guard_with, :children)
      params ||= {}
      children ||= []
      send type, params do
        guard_with { build_from_hash(guard_with) } if guard_with
        children.each { build_from_hash(_1) }
      end
    end

    TASKS_MAP = {
      # leaf tasks
      failure: LeafTasks::Failure,
      success: LeafTasks::Success,
      wait: LeafTasks::Wait,
      # decorators
      always_fail: Decorators::AlwaysFail,
      always_succeed: Decorators::AlwaysSucceed,
      invert: Decorators::Invert,
      repeat: Decorators::Repeat,
      until_fail: Decorators::UntilFail,
      until_success: Decorators::UntilSuccess,
      # branch tasks
      selector: BranchTasks::Selector,
      sequence: BranchTasks::Sequence,
      random_selector: BranchTasks::RandomSelector,
      random_sequence: BranchTasks::RandomSequence,
      dynamic_guard_selector: BranchTasks::DynamicGuardSelector
    }

    def self.add_task_type(name, type)
      define_method name do |params = {}, &block|
        add_task(type, **params, &block)
      end
    end

    TASKS_MAP.each do |name, type|
      add_task_type(name, type)
    end
  end
end
