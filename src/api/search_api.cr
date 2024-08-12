require "./api_client"
require "./exceptions"
require "uri"
require "json"

class SearchApi
  def initialize(@api_client : ApiClient = ApiClient.new)
  end

  def percolate(index : String, percolate_request : Json, async_req : Bool? = nil) : Json
    percolate_with_http_info(index, percolate_request, async_req: async_req)
  end

  def percolate_with_http_info(index : String, percolate_request : Json, async_req : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `index` when calling `percolate`") unless index
    raise ApiValueError.new("Missing the required parameter `percolate_request` when calling `percolate`") unless percolate_request

    path_params = {"index" => index}
    query_params = {} of String => String

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["application/json"])
    }

    response = @api_client.call_api(
      "/pq/#{index}/search", 
      "POST",
      query_params: query_params,
      headers: header_params,
      body: percolate_request.to_json
    )

    return response
  end

  def search(search_request : Json, async_req : Bool? = nil) : Json
    search_with_http_info(search_request, async_req: async_req)
  end

  def search_with_http_info(search_request : Json, async_req : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `search_request` when calling `search`") unless search_request

    path_params = {} of String => String
    query_params = {} of String => String

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["application/json"])
    }

    body_params = search_request.as_h.to_json

    response = @api_client.call_api(
      "/search", 
      "POST",
      query_params: query_params,
      headers: header_params,
      body: body_params
    )

    return response
  end
end
