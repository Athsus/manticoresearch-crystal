require "../api_client"
require "../exceptions"
require "uri"
require "json"

module Manticoresearch
  class UtilsApi
    def initialize(@api_client : ApiClient = ApiClient.new)
    end

    def sql(body : String, raw_response : Bool? = nil) : JSON::Any | Array(JSON::Any)
      sql_with_http_info(body, raw_response: raw_response)
    end

    def sql_with_http_info(body : String, raw_response : Bool? = nil) : JSON::Any | Array(JSON::Any)
      # 确保 body 参数存在
      raise ApiValueError.new("Missing the required parameter `body` when calling `sql`") unless body

      # 构建查询参数
      query_params = {} of String => String
      query_params["raw_response"] = raw_response.to_s if raw_response

      # 根据 raw_response 构建 body 参数
      body_params = ""
      if raw_response == false
        body_params = "query="
      elsif raw_response.nil? || raw_response == true
        body_params = "mode=raw&query="
      end

      # 对 body 参数进行 URL 编码
      body_params += URI.encode_path(body)

      # 设置头部参数
      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["text/plain"]) || "text/plain"
      header_params["Content-Type"] = header_content_type

      # 调用 API，传递 URL 编码的 body
      response = @api_client.call_api(
        "/sql", 
        "POST",
        query_params: query_params,
        header_params: header_params,
        body: body_params
      )

      # 输出响应信息调试
      puts "Response: #{response}"

      # 根据 raw_response 控制返回的格式
      return raw_response == false ? [response] : response
    end
  end
end
