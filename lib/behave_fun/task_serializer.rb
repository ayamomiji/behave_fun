module BehaveFun
  module TaskSerializer
    def name
      self.class.name.demodulize.underscore
    end

    def as_json
      data = { type: name }
      data.merge!(params: params) if params.any?
      data.merge!(guard_with: guard.as_json) if guard
      data.merge!(children: children.map { _1.as_json }) if children.any?
      data
    end

    def serializable_status_fields
      []
    end

    def dump_status
      data = serializable_status_fields.inject({}) do |data, method_name|
        data.merge(method_name => send(method_name))
      end
      data.merge!(status: status)
      data.merge!(children: children.map(&:dump_status)) if children.any?
      data
    end

    def restore_status(data)
      @status = data[:status].to_sym

      serializable_status_fields.each do |method_name|
        send("#{method_name}=", data[method_name])
      end

      if data[:children]
        children.zip(data[:children]).each do |child, child_data|
          child.restore_status(child_data)
        end
      end
    end
  end
end
