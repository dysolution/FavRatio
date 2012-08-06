require 'mock_twitter_api'

describe MockTwitterApi do
  before do
    @api = MockTwitterApi.new
  end

  it "should provide 20 favs by default" do
    current_favs = @api.get_favs("1234")
    current_favs.should have(20).items
  end

  it "should provide as many favs as desired" do
    FAV_COUNT = 42
    current_favs = @api.get_favs("1234", count=FAV_COUNT)
    current_favs.should have(FAV_COUNT).items
  end

  it "should provide info for a user" do
    fresh_info = @api.get_user_info("1234")
    fresh_info.screen_name.should match("1234")
    fresh_info.profile_image_url.should match("1234.jpg")
  end
  
  it "should provide a fake tweet with proper attrs" do
    tweets = @api.get_favs("1234", 1)
    tweet = tweets[0]
    %w(id text user created_at).each do |attr|
      tweet.should respond_to(attr.to_sym)
    end
  end

  it "should provide an arbitrary number of tweets" do
    TWEET_COUNT = 42
    tweets = @api.get_favs("1234", TWEET_COUNT)
    tweets.should have(TWEET_COUNT).entries
  end
end
