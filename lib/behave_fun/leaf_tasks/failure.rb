module BehaveFun
  class LeafTasks::Failure < Task
    def execute
      fail
    end
  end
end
