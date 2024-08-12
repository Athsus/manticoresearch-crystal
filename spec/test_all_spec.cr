require "./spec_helper"

describe "ManticoreSearch API Tests" do
  before_all do
    @index_api = ManticoreClient::IndexApi.new("http://localhost:9408")
    @search_api = ManticoreClient::SearchApi.new("http://localhost:9408")
  end

  it "tests IndexApi functions" do
    index_tests = load_fixture("index_tests.json")

    # Test insert
    insert_request = index_tests["insert"]["request"]
    insert_response = @index_api.insert(insert_request)
    insert_response.should eq(index_tests["insert"]["expected_response"])

    # Test delete
    delete_request = index_tests["delete"]["request"]
    delete_response = @index_api.delete(delete_request)
    delete_response.should eq(index_tests["delete"]["expected_response"])

    # Test replace
    replace_request = index_tests["replace"]["request"]
    replace_response = @index_api.replace(replace_request)
    replace_response.should eq(index_tests["replace"]["expected_response"])

    # Test update
    update_request = index_tests["update"]["request"]
    update_response = @index_api.update(update_request)
    update_response.should eq(index_tests["update"]["expected_response"])
  end

  it "tests SearchApi functions" do
    search_tests = load_fixture("search_tests.json")

    # Test search match
    search_request = search_tests["search_match"]["request"]
    search_response = @search_api.search(search_request)
    search_response.should eq(search_tests["search_match"]["expected_response"])

    # Test search no match
    search_request = search_tests["search_no_match"]["request"]
    search_response = @search_api.search(search_request)
    search_response.should eq(search_tests["search_no_match"]["expected_response"])

    # Test percolate
    percolate_request = search_tests["percolate"]["request"]
    percolate_response = @search_api.percolate("test_pq", percolate_request)
    percolate_response.should eq(search_tests["percolate"]["expected_response"])
  end

  it "executes manual tests" do
    manual_tests = load_fixture("manual_tests.json")
    # todo add manual tests
  end
end
