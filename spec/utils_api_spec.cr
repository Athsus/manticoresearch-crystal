require "./spec_helper"

describe Manticoresearch::UtilsApi do
  config = Manticoresearch::Configuration.new("http://localhost:9308")
  api_client = Manticoresearch::ApiClient.new(config)
  utils_api = Manticoresearch::UtilsApi.new(api_client)
  search_api = Manticoresearch::SearchApi.new(api_client)
  index_api = Manticoresearch::IndexApi.new(api_client)

  it "creates test table and verifies it exists" do
    utils_api.sql("DROP TABLE IF EXISTS movies")
  
    # 创建表的 SQL 语句
    sql_query = <<-SQL
      CREATE TABLE IF NOT EXISTS movies (
        title string,
        plot text,
        _year integer,
        rating float,
        cat string
      )
    SQL
  
    # 执行 CREATE TABLE 语句
    response = utils_api.sql(sql_query)
    
    # 检查是否有错误
    response[0]["error"].should eq("")  # 确认没有错误
  
    # 验证表是否存在
    verify_query = "SHOW TABLES LIKE 'movies'"
    verify_response = utils_api.sql(verify_query)
    
    # 如果表创建成功，应该能在表清单中看到 movies 表
    verify_response[0]["total"].should eq(1)  # 确认表存在
  end
  

  it "inserts data into movies" do
    # 构建 SQL 插入数据的语句
    sql_queries = [
      "INSERT INTO movies (id, title, plot, _year, rating, cat) VALUES (1, 'Star Trek 2: Nemesis', 'The Enterprise is diverted to the Romulan homeworld Romulus...', 2002, 6.4, 'R')",
      "INSERT INTO movies (id, title, plot, _year, rating, cat) VALUES (2, 'Star Trek 1: Nemesis', 'The Enterprise is diverted to the Romulan homeworld Romulus...', 2001, 6.5, 'PG-13')",
      "INSERT INTO movies (id, title, plot, _year, rating, cat) VALUES (3, 'Star Trek 3: Nemesis', 'The Enterprise is diverted to the Romulan homeworld Romulus...', 2003, 6.6, 'R')",
      "INSERT INTO movies (id, title, plot, _year, rating, cat) VALUES (4, 'Star Trek 4: Nemesis', 'The Enterprise is diverted to the Romulan homeworld Romulus...', 2003, 6.5, 'R')"
    ]

    # 执行每个 SQL 插入语句
    sql_queries.each do |query|
      response = utils_api.sql(query, raw_response=true)
      response[0]["total"].should eq(1)  # 每条插入应该影响1行
    end
  end

  it "selects data from movies" do

    sql_query = "SELECT * FROM movies WHERE id = 1"
    response = utils_api.sql(sql_query, raw_response: true)
    result = response[0]["data"]
    result[0]["title"].should eq("Star Trek 2: Nemesis")
    result[0]["_year"].should eq(2002)
    result[0]["rating"].should eq(6.4)
  end

  it "performs complex queries" do

    sql_query = <<-SQL
      SELECT title, AVG(rating) as avg_rating 
      FROM movies 
      WHERE _year >= 2000 
      GROUP BY title
    SQL
    response = utils_api.sql(sql_query, raw_response: true)
    result = response[0]["data"]
    result[0]["avg_rating"].should eq(6.5)  # 确认返回的平均评分正确
  end

  it "updates data in movies" do

    sql_query = "UPDATE movies SET rating = 9.0 WHERE id = 1"
    response = utils_api.sql(sql_query)
    response[0]["error"].should eq("")  # 确认更新成功

    # 验证更新后的数据
    select_query = "SELECT rating FROM movies WHERE id = 1"
    response = utils_api.sql(select_query, raw_response=true)

    result = response[0]["data"]
    result[0]["rating"].should eq(9.0)
  end

  it "deletes data from movies" do

    sql_query = "DELETE FROM movies WHERE id = 1"
    response = utils_api.sql(sql_query, raw_response=true)
    response[0]["error"].should eq("")  # 确认删除成功

    # 验证数据已被删除
    select_query = "SELECT * FROM movies WHERE id = 1"
    response = utils_api.sql(select_query, raw_response=true)
    response[0]["total"].should eq(0)
  end

  it "drops movies table" do

    sql_query = "DROP TABLE movies"
    response = utils_api.sql(sql_query)
    response[0]["error"].should eq("")  # 确认删除成功
  end

end