Given /^there are no tweets$/ do
  Tweet.delete_all
end

Given /^a user to be crawled$/ do
  user = TwitterUser.new
  user.twitter_uid = 6699552
  user.save
end


When /^I request a crawl$/ do
  TwitterUser.first.crawl
end

Then /^there should be new tweets$/ do
  Tweet.count.should have_at_least(1).items
end
