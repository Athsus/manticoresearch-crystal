require "./spec_helper"

describe Manticoresearch::SearchApi do
  config = Manticoresearch::Configuration.new("http://localhost:9308")
  api_client = Manticoresearch::ApiClient.new(config)
  utils_api = Manticoresearch::UtilsApi.new(api_client)
  search_api = Manticoresearch::SearchApi.new(api_client)
  index_api = Manticoresearch::IndexApi.new(api_client)

  it "performs a search and validates results" do
    

    # 删除文档，确保干净的状态（如果存在则删除）
    delete_req_body = { "index" => "test", "id" => 1 }
    begin
      index_api.delete(delete_req_body)
    rescue e
      puts "Document not found, nothing to delete: #{e.message}"  # 如果不存在，捕获异常并打印信息
    end

    # 插入测试文档
    insert_req_body = { "index" => "test", "id" => 1, "doc" => { "content" => "sample content", "name" => "test doc", "cat" => "10" } }
    response = index_api.insert(insert_req_body)

    # 执行搜索，查找匹配 "sample" 的文档
    search_req_body = { "index" => "test", "query" => { "match" => { "content" => "sample" } } }
    search_response = search_api.search(search_req_body)
    id = search_response["hits"]["hits"][0]["_id"]
    total = search_response["hits"]["total"]

    # 验证搜索结果
    id.should eq(1)  # 文档 ID 应该为 1
    total.should eq(1)  # 搜索到 1 个文档

    # 执行一个无匹配的搜索
    search_req_body_no_match = { "index" => "test", "query" => { "match" => { "content" => "no match" } } }
    no_match_response = search_api.search(search_req_body_no_match)
    no_match_result = no_match_response["hits"]["total"]
    no_match_result.should eq(0)  # 不应找到任何匹配的文档

    # 删除文档，确保干净的状态（如果存在则删除）
    begin
      index_api.delete(delete_req_body)
    rescue e
      puts "Document not found, nothing to delete: #{e.message}"
    end
  end

  it "tests percolate search" do

    utils_api.sql("drop table if exists test_pq")
    utils_api.sql("create table test_pq(title text, color string) type=\'pq\'")
    
    # 插入 percolate 查询文档
    percolate_query = { "index" => "test_pq", "doc" => { "query" => "@title bag" } }
    index_api.insert(percolate_query)

    percolate_query = { "index" => "test_pq", "doc" => { "query" => "@title shoes", "filters"=> "color=\'red\'" } }
    index_api.insert(percolate_query)

    # 执行 percolate 查询，匹配 "sample content"
    percolate_req_body = { "query" => { "percolate" => { "document" => { "title" => "what a nice bag" } } } }
    percolate_response = search_api.percolate("test_pq", percolate_req_body)
    percolate_result = percolate_response["hits"]["hits"][0]

    # 验证 percolate 结果
    percolate_response["hits"]["total"].should eq(1)  # 应该匹配 1 个文档

    # 执行一个无匹配的 percolate 查询
    percolate_req_no_match = { "query" => { "percolate" => { "document" => { "content" => "no match" } } } }
    no_match_response = search_api.percolate("test_pq", percolate_req_no_match)
    no_match_total = no_match_response["hits"]["total"]
    no_match_total.should eq(0)  # 不应找到任何匹配的文档

    utils_api.sql("drop table if exists test_pq")
  end

end
