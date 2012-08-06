require 'spec_helper'
require 'mock_twitter_api'
require 'faved_tweet_parser'

describe FavedTweetParser do
  before do
    @num_new_tweets = 4
    @user = TwitterUser.create(twitter_username: "target_user")
    @crawler = UserCrawler.new(@user, api=MockTwitterApi.new, @num_new_tweets)
  end

  it "records details for all new authors" do
    @crawler.get_favs
    @crawler.retrieved_favs.each do |tweet|
      author = FavedTweetParser.new(tweet, @user).find_or_create_author
      author.twitter_username.should_not be_blank
      author.avatar_url.should_not be_blank
      author.last_refreshed_from_twitter.should be_within(10).of(Time.now.utc)
    end
  end

  it "records details for all new tweets" do
    @crawler.get_favs
    @crawler.retrieved_favs.each do |tweet|
      parser = FavedTweetParser.new(tweet, @user)
      parser.attribute_tweet_to_author
      tweet = parser.tweet
      tweet.twitter_uid.should_not be_blank
      tweet.text.should_not be_blank
      tweet.timestamp.should be_a(Time)
    end
  end
end

describe UserCrawler do
  before(:each) do
    @num_new_tweets = 4
    @user = TwitterUser.create(twitter_username: "target_user")
    @crawler = UserCrawler.new(@user, api=MockTwitterApi.new, @num_new_tweets)
  end

  it "should adjust the crawl interval appropriately" do
    @user.crawl_interval = nil
    @crawler.crawl
    @user.crawl_interval.should_not be_nil
  end
  it "should ensure the crawler waits to run again" do
    id = @user.id
    @user.latest_crawl_time = 5.hours.ago
    @user.prepare_for_next_crawl
    @user = TwitterUser.find(id)
    next_crawl_time = (Time.now + 
                       (@user.crawl_interval - 1).minutes
                      ).utc
    @user.next_crawl_time.utc.should be > next_crawl_time
  end

  context "when there is no new data" do
    [TwitterUser, Tweet, Fav].each do |obj_type|
      it "doesn't save new #{obj_type.to_s.pluralize}" do
        @crawler.crawl
        expect { @crawler.crawl }.should_not change(obj_type, :count)
      end
    end
  end

  context "when there is previously unseen data" do

    [TwitterUser, Tweet, Fav].each do |obj_type|
      it "saves new #{obj_type.to_s.pluralize}" do
        expect do
          @crawler.crawl
        end.should change(obj_type, :count).by(@num_new_tweets)
      end
    end

    it "should report how many new objects of each type were saved" do
      @crawler.crawl
      stats = @crawler.stats
      stats[:new_favs].should == @num_new_tweets
      stats[:new_tweets].should == @num_new_tweets
      stats[:new_authors].should == @num_new_tweets
    end
  end
end
