require "../Manticoresearch/Manticoresearch"
require "json"

# 配置 Manticoresearch 客户端的主机地址
configuration = Manticoresearch::Configuration.new
configuration.host = "http://127.0.0.1:9308" # Manticoresearch 服务的地址

# 初始化 API 客户端
api_client = Manticoresearch::ApiClient.new(configuration)

# 创建 SearchApi 实例
api_instance = Manticoresearch::SearchApi.new(api_client)

# 定义索引名称
index = "index_example" # 替换为实际的 percolate 索引名称

# 定义 percolate 查询请求
percolate_query = {
  "query" => {
    "percolate" => {
      "document" => {
        "content" => "sample content"
      }
    }
  }
}

# 开始进行 percolate 搜索
begin
  # 执行 percolate 搜索请求
  api_response = api_instance.percolate(index, percolate_query)

  # 输出 API 响应
  puts api_response

# 捕获异常并输出错误信息
rescue e : Exception
  puts "Exception when calling SearchApi->percolate: #{e.message}"
end
