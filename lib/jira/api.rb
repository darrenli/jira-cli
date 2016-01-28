require 'faraday'
require 'faraday_middleware'

module Jira
  class API

    def get(path, options={})
      response = client.get(path, options[:params] || {}, headers)
      process(response, options)
    end

    def post(path, options={})
      response = client.post(path, options[:params] || {}, headers)
      process(response, options)
    end

    def patch(path, options={})
      response = client.put(path, options[:params] || {}, headers)
      process(response, options)
    end

    def delete(path, options={})
      response = client.delete(path, options[:params] || {}, headers)
      process(response, options)
    end

  private

    def process(response, options)
      json = response.body || {}
      if response.success?
        if json['errorMessages'].nil?
          respond_to(options[:success], json)
          return json
        end
      end
      puts json['errorMessages'].join('. ') if !json['errorMessages'].nil?
      respond_to(options[:failure], json)
      json
    end

    def respond_to(block, json)
      return if block.nil?
      case block.arity
      when 0
        block.call
      when 1
        block.call(json)
      end
    end

    def client
      @client ||= Faraday.new(endpoint) do |faraday|
        faraday.request  :basic_auth, Jira::Core.username, Jira::Core.password
        faraday.request  :json
        faraday.response :json
        faraday.adapter  :net_http
      end
    end

    def endpoint
      "#{Jira::Core.url}/rest/api/2"
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

  end
end
