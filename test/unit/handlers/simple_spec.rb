require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/handlers/simple'

describe 'Simple Handler' do
  before do
  end

  after do
  end

  describe 'test simple' do

    it 'should construct result message based on spec message format and call_params parameters' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Bundle %{name} started' }
      call_params = { :name => 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple(response, response_spec, call_params)
      expect(result.message).to eq('Bundle somebundle started')
      expect(result.response).to be(response)
    end

  end

  describe 'test simple_true' do

    it 'should construct result message with true data' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Bundle %{name} started' }
      call_params = { :name => 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple_true(response, response_spec, call_params)
      expect(result.message).to eq('Bundle somebundle started')
      expect(result.response).to be(response)
      expect(result.data).to be(true)
    end

  end

  describe 'test simple_false' do

    it 'should construct result message with false data' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Bundle %{name} started' }
      call_params = { :name => 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple_false(response, response_spec, call_params)
      expect(result.message).to eq('Bundle somebundle started')
      expect(result.response).to be(response)
      expect(result.data).to be(false)
    end

  end

end
