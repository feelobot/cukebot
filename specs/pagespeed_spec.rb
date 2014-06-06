require_relative "spec_helper"
require_relative "../lib/pagespeed"

describe "Page Speed" do
  let (:pagespeed) { PageSpeed.new("http://bleacherreport.com","desktop","AIzaSyAaFMim2CY68W2FJzzwSrqChNZ_ebLcm8M") }
  it "should show me how fast" do
    pss = pagespeed.get_results
    expect(pss).to have_key("score")
    expect(pss["score"]).to be >= 0
    expect(pss["score"]).to be <= 100
    puts "Site: bleacherreport.com"
    puts "Page Speed Score: #{pss["score"]}/100"
    jj pss["pageStats"]
    pss["score"].should 
  end
end
