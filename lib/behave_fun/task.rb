module BehaveFun
  class Task
    include TaskSerializer

    attr_accessor :control, :guard, :params
    attr_reader :context, :children, :status

    def initialize(params = {})
      self.params = params
      @children = []
      @status = :fresh
    end

    def self.task_name
      name.demodulize.underscore
    end

    def context=(context)
      @context = context
      children.each { _1.context = context }
    end

    def running
      @status = :running
      control.child_running if control
    end

    def success
      @status = :succeeded
      control.child_success if control
    end

    def fail
      @status = :failed
      control.child_fail if control
    end

    def cancel
      @status = :cancelled
      children.each { |child| child.cancel }
    end

    def fresh?
      @status == :fresh
    end

    def running?
      @status == :running
    end

    def succeeded?
      @status == :succeeded
    end

    def failed?
      @status == :failed
    end

    def cancelled?
      @status == :cancelled
    end

    def ended?
      succeeded? || failed? || cancelled?
    end

    def guard_passed?
      return true unless guard

      guard.context = context
      guard.reset
      guard.run

      case guard.status
      when :succeeded then true
      when :failed    then false
      else
        raise Error, 'Guard should finish in one step'
      end
    end

    def start; end

    def execute; end

    def child_success; end

    def child_fail; end

    def child_running; end

    def add_child(task)
      @children << task
      task.control = self
    end

    def run
      raise Error, 'Cannot run ended task' if ended?
      if fresh?
        if guard_passed?
          start
          running
          execute
        else
          fail
        end
      else
        running
        execute
      end
    end

    def reset
      cancel
      @status = :fresh
      children.each { |child| child.reset }
    end

    def dup
      cloned = self.class.new(params)
      children.each { cloned.add_child(_1.dup) }
      cloned
    end
  end
end
