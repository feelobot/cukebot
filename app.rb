require 'sinatra'
require 'json'
require 'haml'
require 'data_mapper'
require 'yaml'
require_relative 'lib/parser'
require_relative 'lib/test_suite'
require_relative 'models'
require_relative 'lib/slack'

post '/suites' do
  if slack? && complete_deploy?
    parsed_params = Parser.slack(params)
    test_suite = TestSuite.new(parsed_params)
    test_suite.run
    content_type :json
    test_suite.suite.to_json
  elsif slack? && !complete_deploy?
    "Not a valid request"
  else
    test_suite = TestSuite.new(params)
    test_suite.run
    content_type :json
    test_suite.suite.to_json
  end
end

get '/suite/:id' do
  suite = Suite.get(params["id"].to_i)
  content_type :json
  suite.to_json
end

get '/suite/:id/tests' do
  suite = Suite.get(params["id"].to_i)
  tests = suite.tests.all unless suite == nil
  content_type :json
  tests.to_json
end

get '/suite/:id/tests/passed' do
  suite = Suite.get(params["id"].to_i)
  tests = suite.tests.all(:passed => true) unless suite == nil
  content_type :json
  tests.to_json
end

get '/suite/:id/tests/failed' do
  suite = Suite.get(params["id"].to_i)
  tests = suite.tests.all(:passed => false) unless suite == nil
  content_type :json
  tests.to_json
end

get '/suite/:suite/test/:test' do
  suite = Suite.get(params["suite"].to_i)
  test = suite.tests.get(params["test"])
  content_type :json
  test.to_json
end

def slack?
  params["token"] == ENV["SLACK_INTEGRATION_TOKEN"]
end

def complete_deploy?
  params["text"].include?("completed a deploy") && params["text"].include?("_br")
end

get '/' do
  erb :index
end