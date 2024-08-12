require "./api_client"
require "./exceptions"
require "json"

class IndexApi
  def initialize(@api_client : ApiClient = ApiClient.new)
  end

  def bulk(body : String, async_req : Bool? = nil) : Json
    bulk_with_http_info(body, async_req: async_req)
  end

  def bulk_with_http_info(body : String, async_req : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `body` when calling `bulk`") unless body

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["application/x-ndjson"])
    }

    response = @api_client.call_api(
      "/bulk", 
      "POST",
      headers: header_params,
      body: body
    )

    return response
  end

  def delete(delete_document_request : Json, async_req : Bool? = nil) : Json
    delete_with_http_info(delete_document_request, async_req: async_req)
  end

  def delete_with_http_info(delete_document_request : Json, async_req : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `delete_document_request` when calling `delete`") unless delete_document_request

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["application/json"])
    }

    response = @api_client.call_api(
      "/delete", 
      "POST",
      headers: header_params,
      body: delete_document_request.to_json
    )

    return response
  end

  def insert(insert_document_request : Json, async_req : Bool? = nil) : Json
    insert_with_http_info(insert_document_request, async_req: async_req)
  end

  def insert_with_http_info(insert_document_request : Json, async_req : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `insert_document_request` when calling `insert`") unless insert_document_request

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["application/json"])
    }

    response = @api_client.call_api(
      "/insert", 
      "POST",
      headers: header_params,
      body: insert_document_request.to_json
    )

    return response
  end

  def replace(insert_document_request : Json, async_req : Bool? = nil) : Json
    replace_with_http_info(insert_document_request, async_req: async_req)
  end

  def replace_with_http_info(insert_document_request : Json, async_req : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `insert_document_request` when calling `replace`") unless insert_document_request

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["application/json"])
    }

    response = @api_client.call_api(
      "/replace", 
      "POST",
      headers: header_params,
      body: insert_document_request.to_json
    )

    return response
  end

  def update(update_document_request : Json, async_req : Bool? = nil) : Json
    update_with_http_info(update_document_request, async_req: async_req)
  end

  def update_with_http_info(update_document_request : Json, async_req : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `update_document_request` when calling `update`") unless update_document_request

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["application/json"])
    }

    response = @api_client.call_api(
      "/update", 
      "POST",
      headers: header_params,
      body: update_document_request.to_json
    )

    return response
  end

  def update_partial(index : String, id : Float, replace_document_request : Json, async_req : Bool? = nil) : Json
    update_partial_with_http_info(index, id, replace_document_request, async_req: async_req)
  end

  def update_partial_with_http_info(index : String, id : Float, replace_document_request : Json, async_req : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `index` when calling `update_partial`") unless index
    raise ApiValueError.new("Missing the required parameter `id` when calling `update_partial`") unless id
    raise ApiValueError.new("Missing the required parameter `replace_document_request` when calling `update_partial`") unless replace_document_request

    path_params = {
      "index" => index,
      "id" => id.to_s
    }

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["application/json"])
    }

    response = @api_client.call_api(
      "/#{index}/_update/#{id}", 
      "POST",
      headers: header_params,
      body: replace_document_request.to_json
    )

    return response
  end
end
