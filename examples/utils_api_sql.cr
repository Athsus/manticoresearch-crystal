# 引入 Manticoresearch 库
require "../Manticoresearch/Manticoresearch"

# 配置 Manticoresearch 客户端
configuration = Manticoresearch::Configuration.new
configuration.host = "http://127.0.0.1:9308" # 指定 Manticoresearch 服务的地址和端口

# 初始化 API 客户端
api_client = Manticoresearch::ApiClient.new(configuration)

# 创建 UtilsApi 的实例，用于执行 SQL 请求
api_instance = Manticoresearch::UtilsApi.new(api_client)

# 定义 SQL 查询语句
body = "SHOW TABLES" # 这条 SQL 查询用于显示所有表
raw_response = true   # 可选参数：true 返回所有查询的原始结果，false 针对 Select 查询进行处理

begin
  # 执行 SQL 请求
  api_response = api_instance.sql(body, raw_response)
  
  # 输出 API 的响应
  puts api_response

# 捕获任何可能的异常并输出错误信息
rescue e : Exception
  puts "Exception when calling UtilsApi->sql: #{e.message}"
end
