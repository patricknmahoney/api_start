module DescribableError

  module InstanceMethods
    def json_error(sinatra_ctxt, code, error_details={})
      return_error_body = (
        self.class.transform_error_json ?
        self.class.transform_error_json.call(error_details) :
        error_details
      ).merge({message: exception.message})

      sinatra_ctxt.halt(
        code,
        { 'Content-Type' => 'application/json' },
        JSON.dump(return_error_body)
      )
    end
  end

  module ClassMethods
    def transform_error_keys(&block)
      self.transform_error_json = block.to_proc if block
    end

    def transform_error_json
      @transform_error_json
    end

    def transform_error_json=(block=nil)
      @transform_error_json = block
    end
  end

  def self.included(receiver)
    class << self
      attr_accessor :transform_error_json
    end
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end