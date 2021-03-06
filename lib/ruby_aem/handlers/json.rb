# Copyright 2016-2017 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'json'
require 'ruby_aem/error'

module RubyAem
  # Response handlers for JSON payload.
  module Handlers
    # Handle JSON response payload containing authorizable ID.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.json_authorizable_id(response, response_spec, call_params)
      json = JSON.parse(response.body)
      authorizable_id = nil
      if json['success'] == true && json['hits'].length == 1
        authorizable_id = json['hits'][0]['name']
        call_params[:authorizable_id] = authorizable_id
        message = response_spec['message'] % call_params
      else
        message = "User/Group #{call_params[:name]} authorizable ID not found"
      end

      result = RubyAem::Result.new(message, response)
      result.data = authorizable_id
      result
    end

    # Handle package JSON payload. Result status is determined directly by success field.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params additional call_params information
    # @return RubyAem::Result
    def self.json_package_service(response, _response_spec, _call_params)
      json = JSON.parse(response.body)

      message = json['msg']
      result = RubyAem::Result.new(message, response)

      return result if json['success'] == true
      raise RubyAem::Error.new(message, result)
    end

    # Handle package filter JSON payload.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params additional call_params information
    # @return RubyAem::Result
    def self.json_package_filter(response, response_spec, call_params)
      json = JSON.parse(response.body)

      filter = []
      json.each do |key, _value|
        filter.push(json[key]['root']) unless json[key]['root'].nil?
      end

      message = response_spec['message'] % call_params

      result = RubyAem::Result.new(message, response)
      result.data = filter
      result
    end

    # Handle AEM Health Check Servlet JSON payload.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params additional call_params information
    # @return RubyAem::Result
    def self.json_aem_health_check(response, response_spec, call_params)
      json = JSON.parse(response.body)

      message = response_spec['message'] % call_params

      result = RubyAem::Result.new(message, response)
      result.data = json['results']
      result
    end

    # Extract a list of agent names from getAgents JSON payload.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params additional call_params information
    # @return RubyAem::Result
    def self.json_agents(response, response_spec, call_params)
      json = JSON.parse(response.body)

      agent_names = []
      json.each do |key, _value|
        if (!key.start_with? 'jcr:') && (!key.start_with? 'rep:')
          agent_names.push(key)
        end
      end

      message = response_spec['message'] % call_params

      result = RubyAem::Result.new(message, response)
      result.data = agent_names
      result
    end
  end
end
