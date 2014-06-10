load "helpers/concerns/describable_error.rb"
class PermissionDeniedError < StandardError
  include DescribableError

  transform_error_keys do |error_hash|
    transformed = error_hash.slice(
      "sinatra.error",
      "PATH_INFO",
      "rack.request.query_hash",
      "rack.request.query_string",
      "REQUEST_METHOD"
    ).transform_keys{|kee|
      case
      when kee.match(/sinatra.error/)
        "error_encountered"
      when kee.match(/PATH_INFO/)
        "path_requested"
      when kee.match(/rack.request.query_string/)
        "query_string"
      when kee.match(/rack.request.query_hash/)
        "query_parameters"
      when kee.match(/REQUEST_METHOD/)
        "request_method"
      else
        next
      end
    }
    transformed
  end

end
