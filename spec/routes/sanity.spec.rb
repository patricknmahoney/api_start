require 'spec_helper'


# test sanity route and error handling responsibilities

describe 'sanity route' do
  context 'questioning itself' do

    it 'gives itself as true' do
      get '/sanity?sanity=true'

      sanity_resp = JSON.load(last_response.body).with_indifferent_access

      expect(last_response).to be_ok
      expect(sanity_resp.has_key?(:sanity)).to eql(true)
      expect(sanity_resp[:sanity]).to eql(true)
    end

    it 'gives 400 without the right parameters' do
      get '/sanity'

      sanity_resp = JSON.load(last_response.body).with_indifferent_access

      expect(last_response).to_not be_ok
    end

  end
end

describe "halt_json_error" do
  context 'with keys specified' do
    it 'gives a generic error with revealing keys' do
      get '/sanity'

      sanity_resp = JSON.load(last_response.body).with_indifferent_access

      expect(last_response).to_not be_ok


      expect(sanity_resp.keys.size).to eql(6)

      expect(sanity_resp.has_key?('message')).to eql(true)
      expect(sanity_resp.has_key?('sinatra.error')).to eql(true)
      expect(sanity_resp.has_key?('PATH_INFO')).to eql(true)
      expect(sanity_resp.has_key?('rack.request.query_hash')).to eql(true)
      expect(sanity_resp.has_key?('rack.request.query_string')).to eql(true)
      expect(sanity_resp.has_key?('REQUEST_METHOD')).to eql(true)


    end

  end

end

describe "send_json_error" do

  context "on an error calling ::transform_error_keys" do
    it 'gives a 4xx response' do

      get '/protected'

      sanity_resp = JSON.load(last_response.body).with_indifferent_access
      expect(last_response).to_not be_ok

      expect(sanity_resp.has_key?(:message)).to eql(true)
      expect(sanity_resp.has_key?(:error_encountered)).to eql(true)
      expect(sanity_resp.has_key?(:path_requested)).to eql(true)
      expect(sanity_resp.has_key?(:query_string)).to eql(true)
      expect(sanity_resp.has_key?(:query_parameters)).to eql(true)
      expect(sanity_resp.has_key?(:request_method)).to eql(true)

    end
  end

end