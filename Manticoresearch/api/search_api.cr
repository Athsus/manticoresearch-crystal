require "../api_client"
require "../exceptions"
require "uri"
require "json"

module Manticoresearch

  class SearchApi
    def initialize(@api_client : ApiClient = ApiClient.new)
    end

    def percolate(index : String, percolate_request : Hash, async_req : Bool? = nil) : JSON::Any
      percolate_with_http_info(index, percolate_request, async_req: async_req)
    end

    def percolate_with_http_info(index : String, percolate_request : Hash, async_req : Bool? = nil) : JSON::Any
      raise ApiValueError.new("Missing the required parameter `index` when calling `percolate`") unless index
      raise ApiValueError.new("Missing the required parameter `percolate_request` when calling `percolate`") unless percolate_request

      path_params = {"index" => index}
      query_params = {} of String => String

      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["application/json"]) || "application/json"
      header_params["Content-Type"] = header_content_type

      json_percolate_request = percolate_request.to_json

      response = @api_client.call_api(
        "/pq/#{index}/search", 
        "POST",
        query_params: query_params,
        header_params: header_params,
        body: json_percolate_request
      )

      return response
    end

    def search(search_request : Hash, async_req : Bool? = nil) : JSON::Any
      search_with_http_info(search_request, async_req: async_req)
    end

    def search_with_http_info(search_request : Hash, async_req : Bool? = nil) : JSON::Any
      raise ApiValueError.new("Missing the required parameter `search_request` when calling `search`") unless search_request

      path_params = {} of String => String
      query_params = {} of String => String

      header_params = HTTP::Headers.new
      header_accept = @api_client.select_header_accept(["application/json"]) || "application/json"
      header_params["Accept"] = header_accept

      header_content_type = @api_client.select_header_content_type(["application/json"]) || "application/json"
      header_params["Content-Type"] = header_content_type

      json_search_request = search_request.to_json

      response = @api_client.call_api(
        "/search", 
        "POST",
        query_params: query_params,
        header_params: header_params,
        body: json_search_request
      )

      return response
    end
  end
end