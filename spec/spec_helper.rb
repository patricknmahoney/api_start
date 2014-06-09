ENV["RACK_ENV"] ||= "test"

require 'rspec'
require 'rack/test'

begin
  require_relative '../api.rb'
rescue NameError
  require File.expand_path('../api.rb', __FILE__)
end

module RSpecMixin
  include Rack::Test::Methods
  def app() Api end
end

RSpec.configure { |config|
  config.include RSpecMixin
}

