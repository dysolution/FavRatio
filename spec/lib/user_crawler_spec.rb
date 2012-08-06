require 'spec_helper'
require 'mock_twitter_api'

describe UserCrawler do
  before(:each) do
    @num_new_tweets = 2
    @user = TwitterUser.create
    @crawler = UserCrawler.new(@user, api=MockTwitterApi.new, @num_new_tweets)
  end

  it "should adjust the crawl interval appropriately" do
    @user.crawl_interval = nil
    @crawler.get_favs_and_save_new_objects
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
    before(:each) do
      @crawler.get_favs_and_save_new_objects
    end
    
    [TwitterUser, Tweet, Fav].each do |obj_type|
      it "doesn't save new #{obj_type.to_s.pluralize}" do
        expect do
          @crawler.get_favs_and_save_new_objects
        end.should_not change(obj_type, :count)
      end
    end
  end

  context "when there is previously unseen data" do
    [TwitterUser, Tweet, Fav].each do |obj_type|
      it "saves new #{obj_type.to_s.pluralize}" do
        expect do
          @crawler.get_favs_and_save_new_objects
        end.should change(obj_type, :count).by(@num_new_tweets)
      end
    end
    it "records details for all new authors" do
      @crawler.get_favs
      @crawler.retrieved_favs.each do |tweet|
        author = @crawler.save_previously_unseen_author(tweet)
        author.twitter_username.should_not be_blank
        author.avatar_url.should_not be_blank
        author.last_refreshed_from_twitter.should be_within(10).of(Time.now.utc)
      end
    end
    it "records details for all new tweets" do
      @crawler.get_favs
      @crawler.retrieved_favs.each do |tweet|
        author = TwitterUser.new
        tweet = @crawler.save_previously_unseen_tweet(tweet, author)
        tweet.twitter_uid.should_not be_blank
        tweet.text.should_not be_blank
        tweet.timestamp.should be_a(Time)
      end
    end
    it "knows how many new objects of each type were found" do
      @crawler.get_favs_and_save_new_objects
      @crawler.stat_keeper.fav_count.should == @num_new_tweets
      @crawler.stat_keeper.tweet_count.should == @num_new_tweets
      @crawler.stat_keeper.author_count.should == @num_new_tweets
    end
  end
end
