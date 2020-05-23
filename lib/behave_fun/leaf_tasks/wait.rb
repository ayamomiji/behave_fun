module BehaveFun
  class LeafTasks::Wait < Task
    attr_accessor :counter

    def start
      super
      @counter = 0
    end

    def execute
      if @counter < params[:duration]
        @counter += 1
        running
      else
        success
      end
    end

    def serializable_status_fields
      [:counter]
    end
  end
end
