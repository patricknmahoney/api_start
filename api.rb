#!/usr/bin/env ruby

require 'bundler'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'pry'

## Kernel.load helpers/util modules ##
Dir.glob("helpers/*.rb").each { |util_module|
  load "#{util_module}"
}
# also with error classes/logic -- not trivial for an API
Dir.glob("helpers/errors/*.rb").each { |error_file|
  load "#{error_file}"
}

class Api < Sinatra::Base

  ## for activerecord to work with Sinatra ##
  register Sinatra::ActiveRecordExtension
  set :database_file, "./config/database.yml"
  set :server, :puma
  set :show_exceptions, false

  before do
    content_type :json
  end

  helpers ErrorUtils, SinatraUtils

  error PermissionDeniedError do
    send_json_error 403, env
  end

  error RequiredParameterError do
    halt_json_error 400, env.slice(
      "sinatra.error",
      "PATH_INFO",
      "rack.request.query_hash",
      "rack.request.query_string",
      "REQUEST_METHOD"
    )
  end

  # sanity test
  get '/sanity' do
    if not params[:sanity]
      raise RequiredParameterError
    else
      {:sanity => true}.to_json
    end
  end

  # error test
  get '/protected' do
    raise PermissionDeniedError
  end

  # utility just to work out scoping
  get '/pryopen' do
    binding.pry;
  end


end

