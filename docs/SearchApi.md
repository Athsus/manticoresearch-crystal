# ManticoreSearch::SearchApi

All URIs are relative to *http://127.0.0.1:9308*

## Method | HTTP request | Description
------------- | ------------- | -------------
[**search**](SearchApi.md#search) | **POST** /search | Performs a search on an index.
[**percolate**](SearchApi.md#percolate) | **POST** /pq/{index}/search | Perform a reverse search on a percolate index.

## **search**
> SearchResponse search(search_request : SearchRequest)

Performs a search on an index. 

The method expects a `SearchRequest` object with the following mandatory properties:
        
* `index`: the name of the index to search (String)
        
For more details, see the documentation on [**SearchRequest**](SearchRequest.md).

The method returns an object with the following properties:
        
- `hits`: an object with the following properties:
  - `hits`: an array of hit objects, where each hit object represents a matched document. Each hit object has the following properties:
    - `_id`: the ID of the matched document.
    - `_score`: the score of the matched document.
    - `_source`: the source data of the matched document.
  - `total`: the total number of hits found.
- `timed_out`: a boolean indicating whether the query timed out.
- `took`: the time taken to execute the search query.

In addition, if profiling is enabled, the response will include an additional array with profiling information attached.

### Example

```crystal
require "./manticoresearch"

configuration = ManticoreSearch::Configuration.new
configuration.host = "http://127.0.0.1:9308"

# Create an instance of the API class
api_instance = ManticoreSearch::SearchApi.new(configuration)

# Create SearchRequest
search_request = ManticoreSearch::SearchRequest.new(
  index: "test",
  query: {"query_string" => "find smth"}
)

begin
  # Performs a search
  api_response = api_instance.search(search_request)
  puts api_response
rescue ManticoreSearch::ApiError => e
  puts "Exception when calling SearchApi->search: #{e.message}"
end
```
### Parameters

| Name             | Type                                      | Description                                   | Notes    |
|------------------|-------------------------------------------|-----------------------------------------------|----------|
| **search_request** | [**SearchRequest**](SearchRequest.md)      | The request object for performing a search query. | Required |

### Return type

[**SearchResponse**](SearchResponse.md)
TODO: type needed?

### Authorization

No authorization required.

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

### HTTP response details

| Status code | Description            |
|-------------|------------------------|
| **200**     | Success, query processed |
| **500**     | Server error            |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

---

## **percolate**

> SearchResponse percolate(index : String, percolate_request : PercolateRequest)

Perform a reverse search on a percolate index.

This method must be used only on percolate indexes.

Expects two parameters: the index name and a `PercolateRequest` object with a document or an array of documents to search by.

Here is an example of the object with a single document:

```json
{
  "query": {
    "percolate": {
      "document": {
        "content":"sample content"
      }
    }
  }
}
```
And here is an example of the object with multiple documents:
```json
{
  "query": {
    "percolate": {
      "documents": [
        {
          "content": "sample content"
        },
        {
          "content": "another sample content"
        }
      ]
    }
  }
}
```
### Example

```crystal
require "./manticoresearch"

configuration = ManticoreSearch::Configuration.new
configuration.host = "http://127.0.0.1:9308"

# Create an instance of the API class
api_instance = ManticoreSearch::SearchApi.new(configuration)

index = "index_example"
percolate_query = {
  "query" => {
    "percolate" => {
      "documents" => [
        { "content" => "sample content" },
        { "content" => "another sample content" }
      ]
    }
  }
}

percolate_request = ManticoreSearch::PercolateRequest.new(query: percolate_query)

begin
  # Perform reverse search on a percolate index
  api_response = api_instance.percolate(index, percolate_request)
  puts api_response
rescue ManticoreSearch::ApiError => e
  puts "Exception when calling SearchApi->percolate: #{e.message}"
end
```
### Parameters

| Name                 | Type                                      | Description                                   | Notes    |
|----------------------|-------------------------------------------|-----------------------------------------------|----------|
| **index**             | **String**                                | The name of the percolate index               | Required |
| **percolate_request** | [**PercolateRequest**](PercolateRequest.md) | The request object for reverse search queries | Required |

### Return type

[**SearchResponse**](SearchResponse.md)

### Authorization

No authorization required.

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

### HTTP response details

| Status code | Description            |
|-------------|------------------------|
| **200**     | Success, query processed |
| **500**     | Server error            |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
