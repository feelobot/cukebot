require 'data_mapper'

env = ENV['RACK_ENV'] || "development"
config = YAML.load(ERB.new(File.read('config/database.yml')).result)[env]
DataMapper.setup(:default, config)

class Suite
  include DataMapper::Resource
  property :id, Serial
  property :suite, String
  property :deploy_id, String
  property :status, String
  property :branch, String
  property :repo, String
  property :env, String
  property :all_passed, Boolean
  property :cluster, String
  property :failure_log, Text
  property :last_hash, String
  has n, :tests
end

class Test
  include DataMapper::Resource
  property :id, Serial
  property :name, Text
  property :url , Text
  property :session_id, String
  property :passed, Boolean
  belongs_to :suite
end

DataMapper.auto_upgrade!
DataMapper.finalize
