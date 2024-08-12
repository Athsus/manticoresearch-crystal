require "./configuration"
require "./rest"
require "./exceptions"
require "json"
require "http/client"

class ApiClient
  PRIMITIVE_TYPES = [Int32, Int64, Float64, Bool, String, Nil].concat([Time])

  property configuration : Configuration
  property default_headers : HTTP::Headers = HTTP::Headers.new
  property cookie : String?
  property client_side_validation : Bool

  def initialize(configuration : Configuration = Configuration.default, header_name : String? = nil, header_value : String? = nil, cookie : String? = nil)
    @configuration = configuration
    @client_side_validation = configuration.client_side_validation
    @cookie = cookie
    if header_name && header_value
      @default_headers[header_name] = header_value
    end
    @rest_client = RESTClientObject.new(configuration)
  end

  def user_agent : String
    @default_headers["User-Agent"]? || "manticoresearch/4.1.2/crystal"
  end

  def user_agent=(value : String)
    @default_headers["User-Agent"] = value
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
      body : JSON::Any? = nil,
      post_params : Hash(String, String)? = nil,
      files : Hash(String, String)? = nil,
      response_type : String? = nil,
      _return_http_data_only : Bool = true,
      _preload_content : Bool = true,
      _request_timeout : Int32? = nil
  ) : JSON::Any
    # Configure headers and merge with default headers
    headers = @default_headers.merge(header_params || HTTP::Headers.new)
    headers["Cookie"] = @cookie if @cookie

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
    # Basic deserialization based on response_type
    parsed_data = JSON.parse(data)
    if response_type
      # Here we might convert parsed_data into a specific type if needed
      # This is a simplified approach. You can expand this method as required.
      parsed_data
    else
      parsed_data
    end
  end

  def GET(url : String, headers : HTTP::Headers? = nil, query_params : Hash(String, String)? = nil) : JSON::Any
    call_api(url, "GET", nil, query_params, headers)
  end

  def POST(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : JSON::Any
    call_api(url, "POST", nil, nil, headers, body)
  end

  def PUT(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : JSON::Any
    call_api(url, "PUT", nil, nil, headers, body)
  end

  def DELETE(url : String, headers : HTTP::Headers? = nil, body : JSON::Any? = nil) : JSON::Any
    call_api(url, "DELETE", nil, nil, headers, body)
  end
end
