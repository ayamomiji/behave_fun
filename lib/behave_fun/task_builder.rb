module BehaveFun
  class TaskBuilder
    attr_reader :control

    def initialize(control)
      @control = control
    end

    def add_task(type, **params, &block)
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
      type_name, params, guard_with, children =
        task_hash.values_at(:type, :params, :guard_with, :children)
      params ||= {}
      children ||= []
      type = self.class.tasks[type_name.to_sym]
      add_task type, **params do
        guard_with { build_from_hash(guard_with) } if guard_with
        children.each { build_from_hash(_1) }
      end
    end

    def self.tasks
      @tasks ||= {}
    end

    def self.add_task_type(type, name: type.task_name)
      tasks[name.to_sym] = type
      define_method name do |params = {}, &block|
        add_task(type, **params, &block)
      end
    end
  end
end
