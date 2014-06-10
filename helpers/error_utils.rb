
Dir.glob("helpers/errors/*.rb").each { |error_file|
  load "#{error_file}"
}

module ErrorUtils


  #
  # specifiable helper for aborting an exception
  # calls the error_klass's `json_error` to build json output
  #
  # designed for per-error customization of api output
  #
  # @param code [type] [description]
  # @param error_details = {} [type] [description]
  #
  # @return [type] [description]
  def send_json_error(code, error_details = {})
    error_klass = env.fetch('sinatra.error')
    error_klass.send(:json_error, self, code, error_details)
  end


  #
  # generic helper for aborting an exception;
  # just converts the error to json
  #
  # @param code [type] [description]
  # @param error_details = {} [type] [description]
  #
  # @return [type] [description]
  def halt_json_error(code, error_details = {})
    json_error(env.fetch('sinatra.error'), code, error_details)
  end


  #
  # json representation of an error
  # @param exception [type] [description]
  # @param code [type] [description]
  # @param error_details = {} [type] [description]
  # @example `json_error env.fetch('sinatra.error'), code, error_details`
  #
  # @return [type] [description]
  def json_error(exception, code, error_details = {})
    halt code, { 'Content-Type' => 'application/json' }, JSON.dump({
      message: exception.message
    }.merge(error_details))
  end


end