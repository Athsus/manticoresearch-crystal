require "../Manticoresearch/Manticoresearch"
require "spec"

# TODO: 有点问题

describe Manticoresearch::UtilsApi do
  # 在测试开始前，初始化实例变量
  before_each do
    @config = Manticoresearch::Configuration.new("http://localhost:9308")
    @api_client = Manticoresearch::ApiClient.new(@config)
    @utils_api = Manticoresearch::UtilsApi.new(@api_client)
  end

  # SQL insert 测试
  it "inserts data" do
    sql_query = "INSERT INTO movies (id, title, year, rating) VALUES (1, 'Test Movie', 2021, 8.5)"
    response = @utils_api.sql(sql_query)
    response["affected_rows"].should eq(1)  # 确认插入成功
  end

  # 测试基本的查询操作
  it "selects data" do
    sql_query = "SELECT * FROM movies WHERE id = 1"
    response = @utils_api.sql(sql_query, raw_response: false)
    result = response[0]["result"]
    result[0]["title"].should eq("Test Movie")  # 确认返回的数据正确
    result[0]["year"].should eq(2021)
    result[0]["rating"].should eq(8.5)
  end

  # 测试更新操作
  it "updates data" do
    sql_query = "UPDATE movies SET rating = 9.0 WHERE id = 1"
    response = @utils_api.sql(sql_query)
    response["affected_rows"].should eq(1)  # 确认更新成功

    # 确认更新后的数据
    select_query = "SELECT rating FROM movies WHERE id = 1"
    response = @utils_api.sql(select_query, raw_response: false)
    result = response[0]["result"]
    result[0]["rating"].should eq(9.0)  # 确认评分更新为 9.0
  end

  # 测试复杂的查询操作
  it "performs complex queries" do
    sql_query = <<-SQL
      SELECT title, AVG(rating) as avg_rating 
      FROM movies 
      WHERE year >= 2020 
      GROUP BY title
    SQL
    response = @utils_api.sql(sql_query, raw_response: false)
    result = response[0]["result"]
    result[0]["avg_rating"].should eq(9.0)  # 确认返回的平均评分正确
  end

  # 测试删除操作
  it "deletes data" do
    sql_query = "DELETE FROM movies WHERE id = 1"
    response = @utils_api.sql(sql_query)
    response["affected_rows"].should eq(1)  # 确认删除成功

    # 确认数据已被删除
    select_query = "SELECT * FROM movies WHERE id = 1"
    response = @utils_api.sql(select_query, raw_response: false)
    result = response[0]["result"]
    result.size.should eq(0)  # 确认没有返回任何记录
  end
end
