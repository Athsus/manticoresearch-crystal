require "spec"
require "../src/manticore-search"


def load_fixture(file_name)
    JSON.parse(File.read("spec/fixtures/#{file_name}}"))
end