require 'slackr'

CONFIG = JSON.parse IO.read('config.json')

class Slack
  def initialize
    @slack = Slackr::Webhook.new(CONFIG['slack_username'],ENV["SLACK_TOKEN"], {:channel => CONFIG["slack_channel"],:username => CONFIG["slack_channel_user"]})
  end
  def say(msg)
   @slack.say(msg) unless ENV['RACK_ENV'] == "development"
  end
  def show
    @slack
  end
end
