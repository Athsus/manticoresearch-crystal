

require "json"
require "http/client"
require "./configuration"
require "./rest"
require "./exceptions"

module Manticoresearch

  class ApiClient
    PRIMITIVE_TYPES = [Int32, Float64, Bool, String, Nil].concat([Time])

    property configuration : Configuration
    property default_headers : HTTP::Headers = HTTP::Headers.new
    property cookie : String?
    property client_side_validation : Bool

    def initialize(configuration : Configuration = Configuration.default, header_name : String? = nil, header_value : String? = nil, cookie : String? = nil)
      @configuration = configuration
      @client_side_validation = configuration.client_side_validation
      @cookie = cookie
      @rest_client = RESTClientObject.new(configuration)

      if header_name && header_value
        @default_headers[header_name] = header_value
      end

      # Set default User-Agent.
      @default_headers["User-Agent"] = "manticoresearch/1.0.3/crystal"
    end

    def close
      # Cleanup or close resources if needed
    end

    def call_api(
      resource_path : String,
      method : String,
      path_params : Hash(String, String)? = nil,
      query_params : Hash(String, String)? = nil,
      header_params : HTTP::Headers? = nil,
      body : String | JSON::Any? = nil,
      post_params : Hash(String, String)? = nil,
      files : Hash(String, String)? = nil,
      response_type : String? = nil,
      _return_http_data_only : Bool = true,
      _preload_content : Bool = true,
      _request_timeout : Int32? = nil
    ) : JSON::Any

      # Configure headers and merge with default headers
      headers = HTTP::Headers.new
      @default_headers.each do |key, value|
        headers.add(key, value)
      end

      # 如果 header_params 不为空，则将其添加到 headers 中
      if header_params
        header_params.each do |key, value|
          headers.add(key, value)
        end
      end

      # Construct the full URL
      full_url = @configuration.host + resource_path

      # Handle path parameters
      if path_params
        path_params.each do |key, value|
          full_url.gsub!("{#{key}}", value)
        end
      end      

      # Make the request
      response = @rest_client.request(method, full_url, query_params, headers, body)

      # Handle the response
      deserialize(response.data, response_type)
    end

    def deserialize(data : String, response_type : String?) : JSON::Any
      parsed_data = JSON.parse(data)
      if response_type
        parsed_data
      else
        parsed_data
      end
    end

    def get_resp(url : String, headers : HTTP::Headers? = nil, query_params : Hash(String, String)? = nil) : JSON::Any
      call_api(url, "GET", nil, query_params, headers)
    end

    def post_resp(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : JSON::Any
      call_api(url, "POST", nil, nil, headers, body)
    end

    def put_resp(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : JSON::Any
      call_api(url, "PUT", nil, nil, headers, body)
    end

    def delete_resp(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : JSON::Any
      call_api(url, "DELETE", nil, nil, headers, body)
    end

    # Additional methods from Python version
    def select_header_accept(accepts : Array(String)) : String?
      return nil if accepts.empty?

      accepts.each do |accept|
        return accept if accept == "application/json"
      end

      return accepts.first
    end

    def select_header_content_type(content_types : Array(String)) : String?
      return "application/json" if content_types.empty?

      content_types.each do |content_type|
        return content_type if content_type == "application/json"
      end

      return content_types.first
    end

    def update_params_for_auth(headers : HTTP::Headers, querys : Hash(String, String), auth_settings : Array(String), request_auth : Nil = nil)
      # This method would update headers and query parameters based on authentication settings.
      # Implement this based on how you manage authentication in your Crystal project.
    end

    def sanitize_for_serialization(obj : JSON::Any) : JSON::Any
      case obj
      when Array(JSON::Any)
        obj.map { |item| sanitize_for_serialization(item) }
      when Hash(String, JSON::Any)
        obj.transform_values { |value| sanitize_for_serialization(value) }
      when Time
        obj.to_s
      else
        obj
      end
    end

    def parameters_to_tuples(params : Hash(String, JSON::Any)) : Array(Tuple(String, String))
      params.map { |k, v| Tuple.new(k, v.to_s) }
    end

    def files_parameters(files : Hash(String, String)? = nil) : Array(Tuple(String, String))
      files ? files.map { |k, v| Tuple.new(k, v) } : [] of Tuple(String, String)
    end

    def select_header_accept(accepts : Array(String)) : String?
      # 如果没有指定 Accept 头，返回 nil
      return nil if accepts.empty?
    
      # 优先返回 "application/json" 作为 Accept 头
      accepts.each do |accept|
        return accept if accept == "application/json"
      end
    
      # 如果没有找到 "application/json"，返回第一个 Accept 头
      return accepts.first
    end
    
    
  end

end