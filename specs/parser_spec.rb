require_relative "spec_helper"
require_relative "../lib/parser"

describe ".slack" do
  it "should parse text from a deploy_bot" do
    params = {
      "text" => "BJVTFEWX: feelobot has completed a deploy of qa_master_feelobot to stag_br4. Github Hash is 940c45b. Took 4 mins and 50 secs"
    }
    new_params = Parser.slack(params)
    new_params["deploy_id"].should == "BJVTFEWX"
    new_params["branch"].should == "qa_master_feelobot"
    new_params["env"].should == "4"
    new_params["hash"].should == "940c45b"
  end
end
