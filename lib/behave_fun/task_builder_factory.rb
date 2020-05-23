module BehaveFun
  class TaskBuilderFactory
    attr_reader :tasks

    def initialize(&block)
      @tasks = {}

      add_task_type BehaveFun::LeafTasks::Success
      add_task_type BehaveFun::LeafTasks::Failure
      add_task_type BehaveFun::LeafTasks::Wait
      add_task_type BehaveFun::Decorators::AlwaysSucceed
      add_task_type BehaveFun::Decorators::AlwaysFail
      add_task_type BehaveFun::Decorators::UntilSuccess
      add_task_type BehaveFun::Decorators::UntilFail
      add_task_type BehaveFun::Decorators::Invert
      add_task_type BehaveFun::Decorators::Repeat
      add_task_type BehaveFun::BranchTasks::Sequence
      add_task_type BehaveFun::BranchTasks::Selector
      add_task_type BehaveFun::BranchTasks::RandomSequence
      add_task_type BehaveFun::BranchTasks::RandomSelector
      add_task_type BehaveFun::BranchTasks::DynamicGuardSelector

      instance_eval(&block) if block_given?
    end

    def add_task_type(type, name: type.task_name)
      tasks[name.to_sym] = type
    end

    def add_lambda_task_type(task_name, &block)
      type = Class.new(Task) do
        def name
          task_name
        end

        define_method(:execute, &block)
      end
      tasks[task_name.to_sym] = type
    end

    def build_task(&block)
      task = build_tree(&block).root
      task.control = nil
      task
    end

    def build_tree(&block)
      builder = Builder.new(self, Tree.new)
      builder.instance_eval(&block)
      builder.control
    end

    def build_task_from_hash(hash)
      hash = hash.deep_symbolize_keys
      tree = build_tree do
        build_from_hash(hash)
      end
      tree.root
    end

    def build_tree_from_hash(hash)
      hash = hash.deep_symbolize_keys
      build_tree do
        build_from_hash(hash[:root])
      end
    end

    def build_tree_from_json(json)
      hash = ActiveSupport::JSON.decode(json).deep_symbolize_keys
      build_tree_from_hash(hash)
    end

    def as_json(tree)
      tree.as_json
    end

    def to_json(tree)
      ActiveSupport::JSON.encode(as_json(tree))
    end

    class Builder
      attr_reader :factory, :control

      def initialize(factory, control)
        @factory = factory
        @control = control
      end

      def add_task(type, params = {}, &block)
        task = type.new(params)
        @control.add_child(task)

        if block
          builder = Builder.new(factory, task)
          builder.instance_eval(&block)
        end
      end

      def guard_with(&block)
        builder = Builder.new(factory, Tree.new)
        builder.instance_eval(&block)
        control.guard = builder.control.root
      end

      def include(task)
        cloned_task = task.dup
        @control.add_child(cloned_task)
      end

      def build_from_hash(task_hash)
        type_name, params, guard_with, children =
          task_hash.values_at(:type, :params, :guard_with, :children)
        params ||= {}
        children ||= []
        type = factory.tasks[type_name.to_sym]
        add_task type, **params do
          guard_with { build_from_hash(guard_with) } if guard_with
          children.each { build_from_hash(_1) }
        end
      end

      def method_missing(name, *args, &block)
        type = factory.tasks[name.to_sym]
        if type
          add_task(type, *args, &block)
        else
          super
        end
      end
    end
  end
end
