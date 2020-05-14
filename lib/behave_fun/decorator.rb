module BehaveFun
  class Decorator < Task
    def execute
      children[0].run
    end

    def child_success
      success
    end

    def child_fail
      fail
    end

    def child_running
      running
    end

    def add_child(child)
      if children.size > 0
        raise Error, 'A decorator task cannot have more than one child'
      end
      super
    end
  end
end
