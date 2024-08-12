

# The base exception class for all OpenAPIExceptions
class OpenApiException < Exception
end

# Exception for TypeErrors
class ApiTypeError < OpenApiException
  property path_to_item : Array(String)?
  property valid_classes : Array(Class)?
  property key_type : Bool?

  def initialize(msg : String, path_to_item : Array(String)? = nil, valid_classes : Array(Class)? = nil, key_type : Bool? = nil)
    @path_to_item = path_to_item
    @valid_classes = valid_classes
    @key_type = key_type
    full_msg = path_to_item ? "#{msg} at #{render_path(path_to_item)}" : msg
    super(full_msg)
  end
end

# Exception for ValueErrors
class ApiValueError < OpenApiException
  property path_to_item : Array(String)?

  def initialize(msg : String, path_to_item : Array(String)? = nil)
    @path_to_item = path_to_item
    full_msg = path_to_item ? "#{msg} at #{render_path(path_to_item)}" : msg
    super(full_msg)
  end
end

# Exception for AttributeErrors
class ApiAttributeError < OpenApiException
  property path_to_item : Array(String)?

  def initialize(msg : String, path_to_item : Array(String)? = nil)
    @path_to_item = path_to_item
    full_msg = path_to_item ? "#{msg} at #{render_path(path_to_item)}" : msg
    super(full_msg)
  end
end

# Exception for KeyErrors
class ApiKeyError < OpenApiException
  property path_to_item : Array(String)?

  def initialize(msg : String, path_to_item : Array(String)? = nil)
    @path_to_item = path_to_item
    full_msg = path_to_item ? "#{msg} at #{render_path(path_to_item)}" : msg
    super(full_msg)
  end
end

# Generic API Exception
class ApiException < OpenApiException
  property status : Int32?
  property reason : String?
  property body : String?
  property headers : HTTP::Headers?

  def initialize(status : Int32? = nil, reason : String? = nil, http_resp : HTTP::Client::Response? = nil)
    if http_resp
      @status = http_resp.status_code
      @reason = http_resp.status_message
      @body = http_resp.body.try &.gets_to_end
      @headers = http_resp.headers
    else
      @status = status
      @reason = reason
      @body = nil
      @headers = nil
    end
  end

  def to_s : String
    error_message = "(#{@status})\nReason: #{@reason}\n"
    if @headers
      error_message += "HTTP response headers: #{@headers}\n"
    end
    if @body
      error_message += "HTTP response body: #{@body}\n"
    end
    error_message
  end
end

# Renders a string representation of a path
def render_path(path_to_item : Array(String)) : String
  result = ""
  path_to_item.each do |pth|
    if pth.is_a?(Int)
      result += "[#{pth}]"
    else
      result += "['#{pth}']"
    end
  end
  result
end
