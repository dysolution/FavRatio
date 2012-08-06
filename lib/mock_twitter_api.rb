require 'twitter_api'
require 'rspec/mocks'
require 'stub_helper'

class MockTwitterApi < TwitterApi
  # For testing purposes, this "API" returns mock objects
  # similar to the real Twitter API.
  #
  include StubHelper

  def initialize
    RSpec::Mocks::setup(self)
  end

  def get_user_info(twitter_uid)
    twitter_user = double("twitter_user_#{twitter_uid}")
    twitter_user.stub(:id).and_return(twitter_uid)
    twitter_user.stub(:screen_name).
      and_return("current_username_#{twitter_uid}")
    twitter_user.stub(:profile_image_url).
      and_return("http://example.com/current_avatar_#{twitter_uid}.jpg")
    twitter_user
  end

  def get_favs(twitter_uid, count=20)
    tweets = []
    1.upto(count) { |id| tweets << fake_tweet(id) }
    tweets
  end

  def get_crawlable_users
    %w(12345 678910 11 12)
  end

  private

  def fake_tweet(uid)
    author = get_user_info(uid)
    tweet = mock("tweet_#{uid}")
    create_string_stubs(uid, tweet, %w(id text))
    tweet.stub(:user).and_return(author)
    tweet.stub(:created_at).and_return(Time.now.utc)
    tweet
  end
end
