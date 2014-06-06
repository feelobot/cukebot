require_relative 'spec_helper'
require_relative '../lib/slack'

describe "#initialize" do
  it "can send a message to the #cukes channel" do
    slackobj = Slack.new
    slackobj.show.should be_an_instance_of Slackr::Webhook
  end

end
