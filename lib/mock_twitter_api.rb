require 'twitter_api'
require 'rspec/mocks'
require 'twitter_user_provider'
require 'tweet_provider'

class MockTwitterApi < TwitterApi
  # For testing purposes, this "API" returns mock objects
  # similar to the real Twitter API.
  #
  def initialize
    RSpec::Mocks::setup(self)
  end

  def get_user_info(twitter_uid)
    twitter_user = double("twitter_user")
    twitter_user.stub(:screen_name).and_return("current_username_#{twitter_uid}")
    twitter_user.stub(:profile_image_url).and_return("http://example.com/current_avatar_#{twitter_uid}.jpg")
    twitter_user
  end

  def get_favs(twitter_uid, count=20)
    tweets = []
    1.upto count do |n|
      author = TwitterUserProvider.new.mock_instance(n)
      tweets << TweetProvider.new(author).mock_instance(n)
    end
    tweets
  end
end
