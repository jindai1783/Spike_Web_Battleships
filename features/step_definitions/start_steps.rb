Given(/^I am on the homepage$/) do
  visit '/'
end

When(/^I follow "(.*?)"$/) do |arg1|
  click_on arg1
end

Then(/^I should see "(.*?)"$/) do |arg1|
  page.has_content?(arg1)
end