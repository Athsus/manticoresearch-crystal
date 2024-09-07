require "log"
require "openssl"


module Manticoresearch
  class Configuration
    JSON_SCHEMA_VALIDATION_KEYWORDS = %w[multipleOf maximum exclusiveMaximum minimum exclusiveMinimum maxLength minLength pattern maxItems minItems]

    # Base URL for the API
    property host : String = "http://127.0.0.1:9308"
    # API key storage
    property api_key : Hash(String, String) = Hash(String, String).new
    property api_key_prefix : Hash(String, String) = Hash(String, String).new
    # Authentication settings
    property username : String?
    property password : String?
    property client_side_validation : Bool = true
    # SSL settings
    property verify_ssl : Bool = true
    property ssl_ca_cert : String?
    property cert_file : String?
    property key_file : String?
    property assert_hostname : Bool?
    # Logging settings
    property logger : Log = Log.for("stdout")
    property debug : Bool = false
    # Connection pool settings
    property connection_pool_maxsize : Int32 = (4 * 5)
    # Proxy settings
    property proxy : String?
    property proxy_headers : HTTP::Headers? = nil
    

    # Constructor
    def initialize(host : String? = nil, api_key : Hash(String, String)? = nil, api_key_prefix : Hash(String, String)? = nil, username : String? = nil, password : String? = nil)
      @host = host || @host
      @api_key = api_key || @api_key
      @api_key_prefix = api_key_prefix || @api_key_prefix
      @username = username
      @password = password
      @logger = Log.for("stdout")

      if @debug
        @logger.level = Log::Severity::Debug
      else
        @logger.level = Log::Severity::Info
      end
    end

    def self.default : Configuration
      @@default ||= Configuration.new
    end

    def get_api_key_with_prefix(identifier : String) : String?
      key = @api_key[identifier]
      prefix = @api_key_prefix[identifier]
      if key && prefix
        "#{prefix} #{key}"
      elsif key
        key
      else
        nil
      end
    end

    def get_basic_auth_token : String?
      if @username && @password
        return "#{@username}:#{@password}".encode
      end
      nil
    end

    def to_debug_report : String
      <<-REPORT
      Crystal SDK Debug Report:
      OS: #{`uname -s`}
      Crystal Version: #{Crystal::VERSION}
      Version of the API: 3.3.1
      SDK Package Version: 4.1.2
      REPORT
    end

    def host_from_settings(index : Int32 = 0) : String
      @host
    end
  end
end