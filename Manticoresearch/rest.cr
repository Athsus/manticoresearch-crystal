require "http/client"
require "openssl"
require "json"
require "./exceptions"

module Manticoresearch

  class RESTResponse
    property status : Int32
    property reason : String?
    property data : String
    property headers : HTTP::Headers

    def initialize(response : HTTP::Client::Response)
      @status = response.status_code
      @reason = response.status_message
      @data = response.body.not_nil!
      @headers = response.headers
    end

    def getheaders : HTTP::Headers
      @headers
    end

    def getheader(name : String, default_value : String? = nil) : String?
      @headers[name] || default_value
    end
  end

  class RESTClientObject
    def initialize(@configuration : Configuration)
      uri = URI.parse(@configuration.host)
      host = uri.host || "localhost"
      port = uri.port || 9208
      
      @client = HTTP::Client.new(host, port)
    end

    def request(
        method : String, 
        url : String, 
        query_params : Hash(String, String)? = nil, 
        headers : HTTP::Headers? = nil, 
        body : String? | JSON::Any? = nil
      ) : RESTResponse
      # Setup headers and params
      headers ||= HTTP::Headers.new

      full_url = url

      # Add query parameters to URL
      if query_params && !query_params.empty?
        query_string = query_params.map { |k, v| "#{k}=#{v}" }.join("&")
        full_url += "?" + query_string
      end

      # Send request
      response = case method.upcase
                when "GET"
                  @client.get(full_url, headers: headers)
                when "POST"
                  @client.post(full_url, headers: headers, body: body)
                when "PUT"
                  @client.put(full_url, headers: headers, body: body)
                when "DELETE"
                  @client.delete(full_url, headers: headers)
                else
                  raise ApiException.new(reason: "Unsupported HTTP method: #{method}")
                end

      # Handle the response
      rest_response = RESTResponse.new(response)

      # todo delete
      puts "REST Response:"
      puts "Status: #{rest_response.status}"
      puts "Reason: #{rest_response.reason}"
      puts "Data: #{rest_response.data}"
      puts "Headers: #{rest_response.headers}"
      
      if rest_response.status < 200 || rest_response.status >= 300
        raise ApiException.new(http_resp: response)
      end

      puts "success"

      rest_response
    end
  end
end