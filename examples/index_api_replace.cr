require "../manticoresearch"

# 配置 Manticoresearch 客户端
configuration = Manticoresearch::Configuration.new(
  host: "http://127.0.0.1:9308" # Manticoresearch 服务地址
)

# 初始化 API 客户端
api_client = Manticoresearch::ApiClient.new(configuration)

# 创建 IndexApi 实例
api_instance = Manticoresearch::IndexApi.new(api_client)

# 定义替换文档的请求
replace_document_request = {
  "index" => "movies",
  "id" => 1,
  "doc" => {
    "title" => "Updated movie",
    "plot" => "A secret team goes to South Pole",
    "year" => 2020,
    "rating" => 8.7,
    "lat" => 60.4,
    "lon" => 51.99,
    "advise" => "PG",
    "meta" => {"keywords" => ["exploration", "ice"], "genre" => ["drama"]},
    "language" => [2, 3]
  }
}

# 执行替换操作
begin
  api_response = api_instance.replace(replace_document_request)
  puts api_response
rescue e : Exception
  puts "Exception when calling IndexApi->replace: #{e.message}"
end
