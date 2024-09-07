# Manticore Crystal Client

Client for Manticore Search.

## Installation & Usage

### Install with Shards

TODO: installation not tested

To add the `manticoresearch` package to your Crystal project, add the following to your `shard.yml`:

```yaml
dependencies:
  manticoresearch:
    github: Athsus/manticoresearch-crystal
    version: ~> 1.0.0
```
Then run ```shards install``` to install dependencies

## Example Usage
```
require "manticoresearch"

# Define the Manticore Search configuration
config = Manticoresearch::Configuration.new("http://127.0.0.1:9308")

# Initialize the API client
api_client = Manticoresearch::ApiClient.new(config)

# Create an instance of the Index API
index_api = Manticoresearch::IndexApi.new(api_client)

# Perform a bulk insert
body = <<-NDJSON
{"insert": {"index": "test", "id": 1, "doc": {"title": "Title 1"}}}
{"insert": {"index": "test", "id": 2, "doc": {"title": "Title 2"}}}
NDJSON

begin
  # Bulk index operation
  response = index_api.bulk(body)
  puts response
rescue ex : Exception
  puts "Error: #{ex.message}"
end

# Search example
search_api = Manticoresearch::SearchApi.new(api_client)
search_request = {
  "index" => "test",
  "query" => { "match" => { "title" => "Title 1" } }
}

begin
  # Perform a search
  search_response = search_api.search(search_request)
  puts search_response
rescue ex : Exception
  puts "Error: #{ex.message}"
end

```

## API Documentation

All URIs are relative to `http://127.0.0.1:9308`.

### API Endpoints

| Class        | Method     | HTTP request                | Description                                      |
|--------------|------------|-----------------------------|--------------------------------------------------|
| **IndexApi** | `bulk`     | **POST** `/bulk`            | Bulk index operations                            |
| **IndexApi** | `delete`   | **POST** `/delete`          | Delete a document in an index                    |
| **IndexApi** | `insert`   | **POST** `/insert`          | Create a new document in an index                |
| **IndexApi** | `replace`  | **POST** `/replace`         | Replace a document in an index                   |
| **IndexApi** | `update`   | **POST** `/update`          | Update a document in an index                    |
| **SearchApi** | `percolate` | **POST** `/pq/{index}/search` | Perform reverse search on a percolate index    |
| **SearchApi** | `search`  | **POST** `/search`          | Performs a search on an index                    |
| **UtilsApi** | `sql`      | **POST** `/sql`             | Perform SQL queries                              |


For full API reference, please refer to the [Manticore Search Documentation](https://manual.manticoresearch.com).

## Author

- [Athsus](https://github.com/Athsus) - creator