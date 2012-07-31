require 'spec_helper'

describe UserCrawler do
  before(:each) do
    # mock TwitterUsers to be saved as authors
    1.upto 3 do |n|
      instance_variable_set("@user#{n}",
        double("user#{n}",
               id: "#{n}",
               screen_name: "#{n}", 
               profile_image_url: "http://f.oo/#{n}.jpg"))
    end
    # mock Tweets to be saved
    1.upto 3 do |n|
      author = instance_variable_get("@user#{n}")
      instance_variable_set("@tweet#{n}",
        double("tweet#{n}",
               id: "#{n}",
               text: "#{n}",
               user: author,
               created_at: Time.now.utc))
    end
    @user = TwitterUser.create
    @fav_provider = double("fav_source")
    @fav_provider.stub(:get_favs) do
      [@tweet1, @tweet2, @tweet3]
    end
    @crawler = UserCrawler.new(@user)
    @crawler.fav_provider = @fav_provider
  end

  it "should retrieve favs" do
    @fav_provider.get_favs.should have(3).entries
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
    @user.next_crawl_time.utc.should be > (Time.now + (@user.crawl_interval - 1).minutes).utc
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
        end.should change(obj_type, :count).by(3)
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
  end
end
