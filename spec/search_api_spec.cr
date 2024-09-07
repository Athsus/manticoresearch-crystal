require "../Manticoresearch/Manticoresearch"
require "spec"

describe Manticoresearch::SearchApi do
  before_each do
    # 初始化配置和客户端
    @config = Manticoresearch::Configuration.new("http://localhost:9308")
    @api_client = Manticoresearch::ApiClient.new(@config)
    @api = Manticoresearch::SearchApi.new(@api_client)
    @index_api = Manticoresearch::IndexApi.new(@api_client)
  end

  # 测试 percolate 功能
  it "performs reverse search on a percolate index" do
    # 插入文档到 percolate index
    insert_req_body = {
      "index" => "test_pq",
      "id" => 1,
      "doc" => {"query" => "@content sample content"}
    }
    @index_api.insert(insert_req_body)

    # 执行 percolate 查询
    req_body = {"query" => {"percolate" => {"document" => {"content" => "sample content"}}}}
    api_resp = @api.percolate("test_pq", req_body)
    res = {
      hits: api_resp["hits"]["hits"],
      total: api_resp["hits"]["total"],
      profile: api_resp["profile"],
      timed_out: api_resp["timed_out"]
    }
    expected_res = {
      hits: [{_id: "1", _index: "test_pq", _score: "1", _source: {query: {ql: "@content sample content"}}, _type: "doc", fields: {_percolator_document_slot: [1]}}],
      total: 1,
      profile: nil,
      timed_out: false
    }
    res.should eq(expected_res)

    # 测试没有匹配的文档
    req_body = {"query" => {"percolate" => {"document" => {"content" => "no match"}}}}
    api_resp = @api.percolate("test_pq", req_body)
    res = {
      hits: api_resp["hits"]["hits"],
      total: api_resp["hits"]["total"],
      profile: api_resp["profile"],
      timed_out: api_resp["timed_out"]
    }
    expected_res = {
      hits: [] of Hash,
      total: 0,
      profile: nil,
      timed_out: false
    }
    res.should eq(expected_res)
  end

  # 测试 search 功能
  it "performs a search" do
    # 删除可能存在的文档
    req_body = {"index" => "test", "id" => 1}
    @index_api.delete(req_body)

    # 插入一个文档
    insert_req_body = {
      "index" => "test",
      "id" => 1,
      "doc" => {
        "content" => "sample content",
        "name" => "test doc",
        "cat" => "10"
      }
    }
    @index_api.insert(insert_req_body)

    # 执行查询
    req_body = {"index" => "test", "query" => {"match" => {"content" => "sample"}}}
    api_resp = @api.search(req_body)
    res = {
      id: api_resp["hits"]["hits"][0]["_id"],
      total: api_resp["hits"]["total"],
      profile: api_resp["profile"],
      timed_out: api_resp["timed_out"]
    }
    expected_res = {
      id: "1",
      total: 1,
      profile: nil,
      timed_out: false
    }
    res.should eq(expected_res)

    # 测试无匹配的查询
    req_body = {"index" => "test", "query" => {"match" => {"content" => "no match"}}}
    api_resp = @api.search(req_body)
    res = {
      hits: api_resp["hits"]["hits"],
      total: api_resp["hits"]["total"],
      profile: api_resp["profile"],
      timed_out: api_resp["timed_out"]
    }
    expected_res = {
      hits: [] of Hash,
      total: 0,
      profile: nil,
      timed_out: false
    }
    res.should eq(expected_res)
  end
end
