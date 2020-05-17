module BehaveFun
  class Tree < Task
    attr_reader :root

    def root=(root)
      @root = root
      @root.control = self
    end

    def tree
      self
    end

    def context=(context)
      @context = context
      @root.context = context
    end

    def execute
      root.run
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

    # tree does not have children, it only contains a root
    def add_child(child)
      self.root = child
    end

    def reset
      super
      root.reset
    end

    def as_json
      {
        version: 1,
        root: root.as_json
      }
    end

    def dump_status
      root.dump_status
    end

    def restore_status(data)
      root.restore_status(data)
    end
  end
end
