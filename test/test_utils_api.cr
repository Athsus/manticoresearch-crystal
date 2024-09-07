require "spectator"  # 使用 Spectator 作为测试框架
require "../Manticoresearch/Manticoresearch"  # 引入被测试的 UtilsApi

Spectator.describe Manticoresearch::UtilsApi do
  # 在测试开始前，创建 UtilsApi 实例和测试用数据
  before_each do
    @config = Manticoresearch::Configuration.new("http://localhost:9308")
    @api_client = Manticoresearch::ApiClient.new(@config)
    @utils_api = Manticoresearch::UtilsApi.new(@api_client)
  end

  # 假设的 SQL 数据插入操作
  it "inserts data" do
    sql_query = "INSERT INTO movies (id, title, year, rating) VALUES (1, 'Test Movie', 2021, 8.5)"
    response = @utils_api.sql(sql_query)
    expect(response["affected_rows"]).to eq(1)  # 确认插入成功
  end

  # 测试基本的查询操作
  it "selects data" do
    sql_query = "SELECT * FROM movies WHERE id = 1"
    response = @utils_api.sql(sql_query, raw_response: false)
    result = response[0]["result"]
    expect(result[0]["title"]).to eq("Test Movie")  # 确认返回的数据正确
    expect(result[0]["year"]).to eq(2021)
    expect(result[0]["rating"]).to eq(8.5)
  end

  # 测试更新操作
  it "updates data" do
    sql_query = "UPDATE movies SET rating = 9.0 WHERE id = 1"
    response = @utils_api.sql(sql_query)
    expect(response["affected_rows"]).to eq(1)  # 确认更新成功

    # 确认更新后的数据
    select_query = "SELECT rating FROM movies WHERE id = 1"
    response = @utils_api.sql(select_query, raw_response: false)
    result = response[0]["result"]
    expect(result[0]["rating"]).to eq(9.0)  # 确认评分更新为 9.0
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
    expect(result[0]["avg_rating"]).to eq(9.0)  # 确认返回的平均评分正确
  end

  # 测试删除操作
  it "deletes data" do
    sql_query = "DELETE FROM movies WHERE id = 1"
    response = @utils_api.sql(sql_query)
    expect(response["affected_rows"]).to eq(1)  # 确认删除成功

    # 确认数据已被删除
    select_query = "SELECT * FROM movies WHERE id = 1"
    response = @utils_api.sql(select_query, raw_response: false)
    result = response[0]["result"]
    expect(result.size).to eq(0)  # 确认没有返回任何记录
  end
end
