require "sauce/cucumber"
require 'json'
require 'data_mapper'
require_relative '../models'
require_relative "slack"

class TestSuite

  attr_reader :suite

  def initialize(opts={})
    @suite = Suite.create
    @suite.branch = opts["branch"]
    @suite.repo = opts["repo"]
    @suite.env = opts["env"]
    @suite.suite = opts["suite"]
    @suite.deploy_id = opts["deploy_id"]
    @suite.status = "running"
    @suite.cluster = opts["cluster"]
    @suite.last_hash = opts["hash"]
    puts @suite.inspect
    @suite.save
  end

  def run
    raise "No Suite Defined" if @suite.suite == nil
    puts "Test suite #{@suite.suite} for #{@suite.deploy_id} have begun id is #{@suite.id}..."
    Slack.new.say("Starting cuke run for #{@suite.suite['deploy_id']} Suite ID: #{@suite.id}")
    Thread.new {
      `SUITE_ID=#{@suite.id} ENV=#{@suite.env} bundle exec parallel_cucumber features/ --group-by scenario --test-options="-p #{@suite.suite}" >> /tmp/#{@suite.id}_#{@suite.deploy_id}_cuke.log`
      @suite.update(:status => "complete")
      all_tests_passed?
      @suite.update(:failure_log => get_log_contents("/tmp/#{@suite.id}_#{@suite.deploy_id}_cuke.log")) if @suite.all_passed == false
    }
  end

  def get_log_contents(file)
    log = File.open(file, "r")
    log_contents = log.read
    log.close
    log_contents
  end

  def all_tests_passed?
    if @suite.tests.all.length == @suite.tests.all(:passed => true).length
      @suite.update(:all_passed => true)
      slack = Slack.new
      slack.say("PASSED!! All tests passed in suite #{@suite.suite} for #{@suite.repo}/#{@suite.branch} on #{@suite.env} for deploy #{@suite.deploy_id}")
      slack.say("Results: http://cukebot-prod-web-c1.elasticbeanstalk.com/suite/#{@suite.id}")
    else
      @suite.update(:all_passed => false)
      slack = Slack.new
      slack.say("FAILED!! Suite: #{@suite.suite} for #{@suite.repo}/#{@suite.branch} on #{@suite.env}bleacherreport.com for deploy #{@suite.deploy_id}")
      slack.say("Results: http://cukebot-prod-web-c1.elasticbeanstalk.com/suite/#{@suite.id}/tests/failed")
    end
  end
end
