require "./api_client"
require "./exceptions"
require "uri"

class UtilsApi
  def initialize(@api_client : ApiClient = ApiClient.new)
  end

  def sql(body : String, raw_response : Bool? = nil) : Json
    sql_with_http_info(body, raw_response: raw_response)
  end

  def sql_with_http_info(body : String, raw_response : Bool? = nil) : Json
    raise ApiValueError.new("Missing the required parameter `body` when calling `sql`") unless body

    query_params = {} of String => String
    query_params["raw_response"] = raw_response.to_s if raw_response

    body_params = if raw_response == false
      "query="
    elsif !raw_response.nil? && raw_response == true
      "mode=raw&query="
    else
      ""
    end

    body_params += URI.encode_www_form_component(body)

    header_params = {
      "Accept" => @api_client.select_header_accept(["application/json"]),
      "Content-Type" => @api_client.select_header_content_type(["text/plain"])
    }

    response = @api_client.call_api(
      "/sql", 
      "POST",
      query_params: query_params,
      headers: header_params,
      body: body_params
    )

    return raw_response == false ? [response] : response
  end
end
