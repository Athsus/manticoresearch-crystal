# Manticore Search Client
# Copyright (c) 2020-2021, Manticore Software LTD
#
# All rights reserved

require "http/client"
require "json"
require "./exceptions"

class RESTResponse
  property status : Int32
  property reason : String?
  property data : String
  property headers : HTTP::Headers

  def initialize(response : HTTP::Client::Response)
    @status = response.status_code
    @reason = response.status_message
    @data = response.body.try &.gets_to_end || ""
    @headers = response.headers
  end

  def getheaders : HTTP::Headers
    @headers
  end

  def getheader(name : String, default_value : String? = nil) : String
    @headers[name] || default_value
  end
end

class RESTClientObject
  def initialize(@configuration : Configuration)
    # Initialize with configuration, managing SSL and connection pools
    @client = HTTP::Client.new(@configuration.host) do |client|
      if @configuration.verify_ssl
        client.ssl_context = OpenSSL::SSL::Context::Client.new
        client.ssl_context.verify_mode = OpenSSL::SSL::VerifyMode::PEER
        client.ssl_context.ca_file = @configuration.ssl_ca_cert || OpenSSL::X509::DEFAULT_CERT_FILE
      end
    end
  end

  def request(method : String, url : String, query_params : Hash(String, String)? = nil, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : RESTResponse
    # Setup headers and params
    headers ||= HTTP::Headers.new
    full_url = @configuration.host + url

    # Add query parameters to URL
    if query_params
      query_string = query_params.map { |k, v| "#{k}=#{v}" }.join("&")
      full_url += "?" + query_string
    end

    # Send request
    response = case method.upcase
               when "GET"
                 @client.get(full_url, headers: headers)
               when "POST"
                 @client.post(full_url, headers: headers, body: body.to_json)
               when "PUT"
                 @client.put(full_url, headers: headers, body: body.to_json)
               when "DELETE"
                 @client.delete(full_url, headers: headers)
               else
                 raise ApiException.new(reason: "Unsupported HTTP method: #{method}")
               end

    # Handle the response
    rest_response = RESTResponse.new(response)
    if rest_response.status < 200 || rest_response.status >= 300
      raise ApiException.new(http_resp: rest_response)
    end

    rest_response
  end

  def GET(url : String, headers : HTTP::Headers? = nil, query_params : Hash(String, String)? = nil) : RESTResponse
    request("GET", url, query_params, headers)
  end

  def POST(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : RESTResponse
    request("POST", url, nil, headers, body)
  end

  def PUT(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : RESTResponse
    request("PUT", url, nil, headers, body)
  end

  def DELETE(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : RESTResponse
    request("DELETE", url, nil, headers, body)
  end
end
