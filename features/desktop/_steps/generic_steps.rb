Given(/^I navigate to "(.*?)"$/) do |link|
  visit link
end

Then(/^their should be no (\d+) error$/) do |arg1|
  raise "500 Internal Error on page" if page.has_content? "Error: 500 Internal Server Error"
end