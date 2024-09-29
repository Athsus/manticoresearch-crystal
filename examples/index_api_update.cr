require "../manticoresearch"

# 配置 Manticoresearch 客户端
configuration = Manticoresearch::Configuration.new(
  host: "http://127.0.0.1:9308" # Manticoresearch 服务地址
)

# 初始化 API 客户端
api_client = Manticoresearch::ApiClient.new(configuration)

# 创建 IndexApi 实例
api_instance = Manticoresearch::IndexApi.new(api_client)

# 定义更新文档的请求
update_document_request = {
  "index" => "movies",
  "id" => 1,
  "doc" => {
    "rating" => 9.49
  }
}

# 执行更新操作
begin
  api_response = api_instance.update(update_document_request)
  puts api_response
rescue e : Exception
  puts "Exception when calling IndexApi->update: #{e.message}"
end
