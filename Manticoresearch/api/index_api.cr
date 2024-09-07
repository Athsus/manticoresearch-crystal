require "../api_client"
require "../exceptions"
require "json"

module Manticoresearch
    # IndexApi - API
  class IndexApi
    def initialize(@api_client : ApiClient = ApiClient.new)
    end

    def bulk(body : Hash, async_req : Bool? = nil) : JSON::Any
      bulk_with_http_info(body, async_req: async_req)
    end

    def bulk_with_http_info(body : Hash, async_req : Bool? = nil) : JSON::Any
      raise ApiValueError.new("Missing the required parameter `body` when calling `bulk`") unless body

      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["application/json"]) || "application/json"
      header_params["Content-Type"] = header_content_type

      json_body = body.to_json

      response = @api_client.call_api(
        "/bulk", 
        "POST",
        header_params: header_params,
        body: json_body
      )

      return response
    end

    def delete(delete_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      delete_with_http_info(delete_document_request, async_req: async_req)
    end

    def delete_with_http_info(delete_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      raise ApiValueError.new("Missing the required parameter `delete_document_request` when calling `delete`") unless delete_document_request

      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["application/json"]) || "application/json"
      header_params["Content-Type"] = header_content_type

      json_delete_document_request = delete_document_request.to_json

      response = @api_client.call_api(
        "/delete", 
        "POST",
        header_params: header_params,
        body: json_delete_document_request
      )

      return response
    end

    def insert(insert_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      insert_with_http_info(insert_document_request, async_req: async_req)
    end

    def insert_with_http_info(insert_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      raise ApiValueError.new("Missing the required parameter `insert_document_request` when calling `insert`") unless insert_document_request

      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["application/json"]) || "application/json"
      header_params["Content-Type"] = header_content_type

      json_insert_document_request = insert_document_request.to_json

      response = @api_client.call_api(
        "/insert", 
        "POST",
        header_params: header_params,
        body: json_insert_document_request
      )

      return response
    end

    def replace(insert_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      replace_with_http_info(insert_document_request, async_req: async_req)
    end

    def replace_with_http_info(insert_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      raise ApiValueError.new("Missing the required parameter `insert_document_request` when calling `replace`") unless insert_document_request

      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["application/json"]) || "application/json"
      header_params["Content-Type"] = header_content_type

      json_insert_document_request = insert_document_request.to_json

      response = @api_client.call_api(
        "/replace", 
        "POST",
        header_params: header_params,
        body: json_insert_document_request
      )

      return response
    end

    def update(update_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      update_with_http_info(update_document_request, async_req: async_req)
    end

    def update_with_http_info(update_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      raise ApiValueError.new("Missing the required parameter `update_document_request` when calling `update`") unless update_document_request

      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["application/json"]) || "application/json"
      header_params["Content-Type"] = header_content_type

      json_update_document_request = update_document_request.to_json

      response = @api_client.call_api(
        "/update", 
        "POST",
        header_params: header_params,
        body: json_update_document_request
      )

      return response
    end

    def update_partial(index : String, id : Float, replace_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      update_partial_with_http_info(index, id, replace_document_request, async_req: async_req)
    end

    def update_partial_with_http_info(index : String, id : Float, replace_document_request : Hash, async_req : Bool? = nil) : JSON::Any
      raise ApiValueError.new("Missing the required parameter `index` when calling `update_partial`") unless index
      raise ApiValueError.new("Missing the required parameter `id` when calling `update_partial`") unless id
      raise ApiValueError.new("Missing the required parameter `replace_document_request` when calling `update_partial`") unless replace_document_request

      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["application/json"]) || "application/json"
      header_params["Content-Type"] = header_content_type

      json_replace_document_request = replace_document_request.to_json

      response = @api_client.call_api(
        "/#{index}/_update/#{id}", 
        "POST",
        header_params: header_params,
        body: json_replace_document_request
      )

      return response
    end
  end
end