require "../Manticoresearch/Manticoresearch"

# 配置 Manticoresearch 客户端
configuration = Manticoresearch::Configuration.new(
  host: "http://127.0.0.1:9308" # Manticoresearch 服务地址
)

# 初始化 API 客户端
api_client = Manticoresearch::ApiClient.new(configuration)

# 创建 IndexApi 实例
api_instance = Manticoresearch::IndexApi.new(api_client)

# 定义插入文档的请求
insert_document_request = {
  "index" => "movies",
  "doc" => {
    "title" => "This is an old movie",
    "plot" => "A secret team goes to North Pole",
    "year" => 1950,
    "rating" => 9.5,
    "lat" => 60.4,
    "lon" => 51.99,
    "advise" => "PG-13",
    "meta" => {"keywords" => ["travel", "ice"], "genre" => ["adventure"]},
    "language" => [2, 3]
  }
}

# 执行插入操作
begin
  api_response = api_instance.insert(insert_document_request)
  puts api_response
rescue e : Exception
  puts "Exception when calling IndexApi->insert: #{e.message}"
end
