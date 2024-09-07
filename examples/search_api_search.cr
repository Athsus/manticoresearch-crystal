# 引入 Manticoresearch 库
require "../Manticoresearch/Manticoresearch"

# 引入 JSON 库用于处理 JSON 数据
require "json"

# 配置 Manticoresearch 客户端连接的主机地址
configuration = Manticoresearch::Configuration.new(
  host: "http://127.0.0.1:9308" # 指定 Manticoresearch 服务的地址和端口
)

# 初始化 API 客户端
api_client = Manticoresearch::ApiClient.new(configuration)

# 创建 SearchApi 的实例，用于执行搜索请求
api_instance = Manticoresearch::SearchApi.new(api_client)

# 开始处理请求并捕获可能的异常
begin
  # 定义搜索请求的内容，指定查询的索引和查询条件
  search_request = {
    "index" => "products", # 查询的索引名称
    "query" => { "query_string" => "@title remove hair" } # 查询条件，匹配 title 中包含 "remove hair" 的记录
  }

  # 使用 SearchApi 执行搜索请求
  api_response = api_instance.search(search_request)
  
  # 输出 API 的响应
  puts api_response

# 捕获任何可能的异常并输出错误信息
rescue e : Exception
  puts "Exception when calling SearchApi->search: #{e.message}"
end
