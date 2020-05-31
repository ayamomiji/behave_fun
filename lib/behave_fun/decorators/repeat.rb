module BehaveFun
  class Decorators::Repeat < Decorator
    attr_accessor :counter

    def start
      super
      @counter = 0
    end

    def child_success
      return @children[0].reset unless params[:times]

      @counter += 1
      if @counter < params[:times]
        @children[0].reset
      else
        success
      end
    end

    def child_fail
      child_success
    end

    def serializable_status_fields
      [:counter]
    end

    def params=(params)
      @params = ParamsSchema[params]
    end

    ParamsSchema = Types::Hash.schema(
      times: Types::Coercible::Integer.optional.default(nil)
    )
  end
end
