# Manticore Search Client Crystal Test Suite

require "../manticoresearch"
require "json"
require "spec"

describe Manticoresearch::IndexApi do
  # 初始化配置和 API 客户端
  config = Manticoresearch::Configuration.new("http://localhost:9308")
  api_client = Manticoresearch::ApiClient.new(config)
  index_api = Manticoresearch::IndexApi.new(api_client)
  utils_api = Manticoresearch::UtilsApi.new(api_client)

  describe "#delete" do
    it "deletes a document successfully" do
      # 插入测试文档
      utils_api.sql("CREATE TABLE delete_test (id INTEGER, content TEXT, cat INTEGER)")
      utils_api.sql("INSERT INTO delete_test VALUES (1, 'sample content 1', 10)")
      utils_api.sql("INSERT INTO delete_test VALUES (2, 'sample content 2', 20)")

      # 准备删除请求，删除id=1的文档
      delete_request = { "index" => "delete_test", "id" => 1 }

      # 调用API删除文档并获取响应
      response = index_api.delete(delete_request)
      puts "Delete response for id 1: #{response.to_json}"  # 输出调试信息

      # 验证响应是否为 'deleted'
      response["result"].should eq("deleted")

      # 删除id=2的文档
      delete_request = { "index" => "delete_test", "id" => 2 }
      response = index_api.delete(delete_request)
      puts "Delete response for id 2: #{response.to_json}"
      response["result"].should eq("deleted")

      # 删除id=3的文档，这个文档不存在
      delete_request = { "index" => "delete_test", "id" => 3 }
      response = index_api.delete(delete_request)
      puts "Delete response for id 3: #{response.to_json}"

      # 构建预期的返回结果
      expected_res = { "deleted" => nil, "id" => 3, "index" => "delete_test", "result" => "not found" }
      response["_id"].should eq(expected_res["id"])
      response["_index"].should eq(expected_res["index"])
      response["result"].should eq(expected_res["result"])

      # 根据查询内容删除文档，没有匹配
      delete_request = { "index" => "delete_test", "query" => { "match" => { "content" => "no match" } } }
      response = index_api.delete(delete_request)
      puts "Delete response for no match: #{response.to_json}"

      expected_res = { "deleted" => 0, "id" => nil, "index" => "delete_test", "result" => nil }
      response["_index"].should eq(expected_res["index"])
      response["deleted"].should eq(expected_res["deleted"])

      # 删除整个索引
      utils_api.sql("DROP TABLE IF EXISTS delete_test")
    end
  end

  describe "#insert" do
    it "inserts a document successfully" do
      # 创建测试表格
      utils_api.sql("DROP TABLE IF EXISTS insert_test")

      insert_request = { "index" => "insert_test", "id" => 1, "doc" => { "content" => "sample content", "name" => "test doc", "cat" => "10" } }

      # 插入文档
      response = index_api.insert(insert_request)
      puts "Insert response: #{response.to_json}"  # 输出调试信息
      response["result"].should eq("created")

      # 删除测试表格
      utils_api.sql("DROP TABLE IF EXISTS insert_test")
    end
  end

  describe "#replace" do
    it "replaces a document successfully" do
      # 创建测试表格
      utils_api.sql("DROP TABLE IF EXISTS replace_test")
      utils_api.sql("CREATE TABLE replace_test (id INTEGER, content TEXT, cat INTEGER)")

      replace_request = { "index" => "replace_test", "id" => 1, "doc" => { "content" => "updated content", "cat" => 11 } }

      # 执行替换操作
      response = index_api.replace(replace_request)
      puts "Replace response: #{response.to_json}"  # 输出调试信息
      response["result"].should eq("updated")

      # 删除测试表格
      utils_api.sql("DROP TABLE IF EXISTS replace_test")
    end
  end

  describe "#update" do
    it "updates a document successfully" do
      # 创建并插入测试数据
      utils_api.sql("DROP TABLE IF EXISTS update_test")
      utils_api.sql("CREATE TABLE update_test (id INTEGER, content TEXT, cat INTEGER)")
      utils_api.sql("INSERT INTO update_test VALUES (1, 'sample content', 10)")

      update_request = { "index" => "update_test", "id" => 1, "doc" => { "cat" => 12 } }

      # 执行更新操作
      response = index_api.update(update_request)
      puts "Update response: #{response.to_json}"  # 输出调试信息
      response["result"].should eq("updated")

      # 删除测试表格
      utils_api.sql("DROP TABLE IF EXISTS update_test")
    end
  end
  
  describe "#bulk" do
    it "validates bulk operation" do
      # 删除并创建测试表格
      utils_api.sql("DROP TABLE IF EXISTS bulk_test")
      utils_api.sql("CREATE TABLE bulk_test (id INTEGER, title TEXT, content TEXT)")

      # 准备 bulk 插入请求的数据
      bulk_data = {
        "actions" => [
          { "insert" => { "_index" => "bulk_test", "_id" => 1, "doc" => { "title" => "Test Title 1", "content" => "Test content 1" } } },
          { "insert" => { "_index" => "bulk_test", "_id" => 2, "doc" => { "title" => "Test Title 2", "content" => "Test content 2" } } },
          { "insert" => { "_index" => "bulk_test", "_id" => 3, "doc" => { "title" => "Test Title 3", "content" => "Test content 3" } } }
        ]
      }

      # 执行 bulk 请求
      response = index_api.bulk(bulk_data)
      puts "Bulk response: #{response.to_json}"  # 调试输出

      # 验证 bulk 操作结果是否成功
      response[0]["total"].should eq(0)
    end
  end
end
