#!/usr/bin/env ruby

require 'bundler'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'pry'

class Api < Sinatra::Base

  ## for activerecord to work with Sinatra ##
  register Sinatra::ActiveRecordExtension
  set :database_file, "./config/database.yml"
  set :server, :puma

  before do
     content_type :json
  end

  # sanity test
  get '/sanity' do
    {:sanity => true}.to_json
  end

  # work out scoping
  get '/pryopen' do
    binding.pry;
  end


end

