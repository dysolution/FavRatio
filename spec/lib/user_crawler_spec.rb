require 'spec_helper'
require 'mock_twitter_api'
require 'faved_tweet_parser'

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
