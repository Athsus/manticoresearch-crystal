# ManticoreSearch::UtilsApi

All URIs are relative to *http://127.0.0.1:9308*

 Method | HTTP request | Description
------------- | ------------- | -------------
[**sql**](UtilsApi.md#sql) | **POST** /sql | Perform SQL requests

## **sql**
> SqlResponse sql(body : String, raw_response : Bool = true)

Perform SQL requests

Run a query in SQL format.
Expects a query string passed through the `body` parameter and an optional `raw_response` parameter that defines the format of the response.
`raw_response` can be set to `false` for Select queries only, e.g., `SELECT * FROM myindex`.
The query string must stay as it is, no URL encoding is needed.
The response object depends on the query executed. In select mode, the response has the same format as the `/search` operation.

### Example

```crystal
require "./manticoresearch"

configuration = ManticoreSearch::Configuration.new
configuration.host = "http://127.0.0.1:9308"

# Create an instance of the API class
api_instance = ManticoreSearch::UtilsApi.new(configuration)

body = "SHOW TABLES" # The SQL query string.
raw_response = true  # Optional: set raw_response to true for all queries, or false for Select queries.

begin
  # Perform SQL requests
  api_response = api_instance.sql(body, raw_response)
  puts api_response
rescue ManticoreSearch::ApiError => e
  puts "Exception when calling UtilsApi->sql: #{e.message}"
end
```

### Parameters

| Name           | Type        | Description                                                                                          | Notes                                       |
| -------------- | ----------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| **body**       | **String**  | The SQL query string to execute.                                                                      | Required                                    |
| **raw_response** | **Bool**   | Optional: defines the format of the response. Can be set to `false` for Select queries, `true` for others. | [optional, default: true]                   |

### Return type

[**SqlResponse**](SqlResponse.md)  TODO: are we going to make a SqlResponse???

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `text/plain`
- **Accept**: `application/json`

### HTTP response details

| Status code | Description                                                                                                                | Response headers |
|-------------|----------------------------------------------------------------------------------------------------------------------------|------------------|
| **200**     | In case of SELECT-only in raw mode, the response schema is the same as the `/search` operation. For raw mode, response depends on the query executed. | - |
| **0**       | Error                                                                                                                      | - |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
