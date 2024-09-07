require "../Manticoresearch/Manticoresearch"

# 配置 Manticoresearch 客户端
configuration = Manticoresearch::Configuration.new(
  host: "http://127.0.0.1:9308" # Manticoresearch 服务地址
)

# 初始化 API 客户端
api_client = Manticoresearch::ApiClient.new(configuration)

# 创建 IndexApi 实例
api_instance = Manticoresearch::IndexApi.new(api_client)

# 定义批量操作的 NDJSON 字符串
body = <<-NDJSON
{"insert": {"index": "test", "id": 1, "doc": {"title": "Title 1"}}}
\n
{"insert": {"index": "test", "id": 2, "doc": {"title": "Title 2"}}}
NDJSON

# 执行批量索引操作
begin
  api_response = api_instance.bulk(body)
  puts api_response
rescue e : Exception
  puts "Exception when calling IndexApi->bulk: #{e.message}"
end
