require 'spec_helper'
require 'faved_tweet_parser'
require 'mock_twitter_api'

describe FavedTweetParser do
  before do
    @user = TwitterUser.create(twitter_username: "target_user")
    @tweet = MockTwitterApi.new.get_favs("1234", 1)[0]
  end

  it "records details for all new authors" do
    author = FavedTweetParser.new(@tweet, @user).find_or_create_author
    author.twitter_username.should_not be_blank
    author.avatar_url.should_not be_blank
    author.last_refreshed_from_twitter.should be_within(10).of(Time.now.utc)
  end

  it "records details for all new tweets" do
    parser = FavedTweetParser.new(@tweet, @user)
    parser.attribute_tweet_to_author
    tweet = parser.tweet
    tweet.twitter_uid.should_not be_blank
    tweet.text.should_not be_blank
    tweet.timestamp.should be_a(Time)
  end
end
