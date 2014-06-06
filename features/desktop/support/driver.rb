require 'capybara/cucumber'
require 'capybara/poltergeist'    
require "sauce/cucumber"
require 'json'
require 'data_mapper'
require 'httparty'
require 'uri'
include RSpec::Matchers 
require_relative("../../../lib/pagespeed")

CONFIG = JSON.parse IO.read('config.json')

##################################################
## CHECK IF REQUEST IS FROM SERVER
##################################################
if ENV['SUITE_ID']
  require_relative '../../../models'
  SUITE = Suite.get(ENV['SUITE_ID'].to_i)
end
##################################################

##################################################
## Make Sauce Labs Naming Conventions Prettier (optional)
##################################################
module Sauce::Capybara::Cucumber
  def file_name_from_scenario(scenario)
    super
    return ""
  end
  def name_from_scenario(scenario)
    # Special behavior to handle Scenario Outlines
    if scenario.instance_of? ::Cucumber::Ast::OutlineTable::ExampleRow
      table = scenario.instance_variable_get(:@table)
      outline = table.instance_variable_get(:@scenario_outline)
      return "#{scenario.scenario_outline.feature.name}: #{outline.title} - #{scenario.name}"
    end
    scenario, feature = _scenario_and_feature_name(scenario)
    return "#{feature} - #{scenario}"
  end
  module_function :name_from_scenario
end
##################################################

##################################################
## Setup Sauce Driver
##################################################
Capybara.default_driver = :sauce
Capybara.default_wait_time = 15
Sauce.config do |c|
  c[:start_tunnel] = false
  c[:browsers] = [
    ["OS X 10.8", "Chrome", nil],
  ]
  c[:public] = "share"
end
##################################################

##################################################
## Setup Default URLS
##################################################
def set_br_host
  ENV['ENV'] ||= "4"
  if ENV['ENV'] == "prod"
    host ="http://bleacherreport.com"
  else
    host = "http://#{ENV['ENV']}bleacherreport.com/"
  end
  Capybara.app_host = host
end
##################################################

##################################################
## Conditionally use poltergeist for @javascript tests
##################################################
unless ENV['LOCAL'] == "1"
  set_br_host
  Capybara.javascript_driver = :poltergeist
  Capybara.register_driver :poltergeist do |app|
    options = {
        :js_errors => true,
        :timeout => 120,
        :debug => false,
        :phantomjs_options => ['--load-images=yes', '--disk-cache=false'],
        :inspector => true,
    }
    Capybara::Poltergeist::Driver.new(app, options)
  end
else
  set_br_host
  Capybara.javascript_driver = :selenium
end
##################################################

##################################################
## Store tests results after test ends
##################################################
After("@sanity") do |scenario|
  if ENV['SUITE_ID']
    @test = Test.create :suite => SUITE
    @test.session_id = page.driver.browser.session_id 
    @test.name = Sauce::Capybara::Cucumber.name_from_scenario(scenario)
    @test.url = "http://www.saucelabs.com/tests/#{@test.session_id}"
    @test.passed = !scenario.failed?
    @test.save
  end
end
##################################################
