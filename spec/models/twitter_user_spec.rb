require 'spec_helper'

describe "Twitter User manager" do

  before do
    tu1 = TwitterUser.create(crawling_enabled: true)
    tu2 = TwitterUser.create(crawling_enabled: false)
  end

  it "should know which Twitter users to crawl" do
    TwitterUser.crawlable.should_not be_empty
  end

  it "should be able to crawl all crawlable users" do
    TwitterUser.should respond_to(:crawl_all)
  end

  it "should crawl all crawlable users" do
    TwitterUser.crawl_all
  end
end

describe TwitterUser do
  before(:each) do
    @user = TwitterUser.new
  end

  it "should provide an array of tweets it has authored" do
    @user.tweets.should be_an(Array)
  end
  it "should know when its favs are stale" do
    @user.next_crawl_time = 23.minutes.ago
    @user.favs_are_stale.should be_true
  end

  describe "should not crawl" do
    before(:each) do
      @user = TwitterUser.create
    end
    example "if twitter_uid is missing" do
      @user.twitter_uid = nil
      @user.crawl.should be_false
    end
    example "if not enough time has passed" do
      @user.next_crawl_time = 5.minutes.from_now
      @user.crawl.should be_false
    end
    example "if crawling is disabled" do
      @user.crawling_enabled = false
      @user.crawl.should be_false
    end
  end

  describe "when crawled" do
    before(:each) do
      @user1 = double("user1", id: "1234")
      @user2 = double("user2", id: "5678")
      @user3 = double("user3", id: "3935")
      @tweet1 = double("tweet1", id: "283533523", 
                   text: "foobar", user: @user1,
                   created_at: Time.now.utc)
      @tweet2 = double("tweet2", id: "209352835", 
                   text: "bar", user: @user2,
                   created_at: Time.now.utc)
      @tweet3 = double("tweet3", id: "939346949", 
                   text: "baz", user: @user3,
                   created_at: Time.now.utc)
      @user = TwitterUser.create
      @fav_provider = double("fav_source")
      @fav_provider.stub(:get_favs) do
        [@tweet1, @tweet2, @tweet3]
      end
      @crawler = TwitterUser::UserCrawler.new(@user)
      @crawler.fav_provider = @fav_provider
    end

    it "should retrieve favs" do
      @fav_provider.get_favs.should have(3).entries
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

#      it "should record fake tweets" do
#        expect do
#          @crawler.save_previously_unseen_objects
#        end.should change(Tweet, :count).by(3)
#      end
#
#      it "should record fake favs" do
#        expect do
#          @crawler.save_previously_unseen_objects
#        end.should change(Fav, :count).by(3)
#      end
    end
  end

end


# == Schema Information
#
# Table name: twitter_users
#
#  id                          :integer          not null, primary key
#  twitter_uid                 :string(255)
#  twitter_username            :string(255)
#  avatar_url                  :string(255)
#  crawl_interval              :integer
#  latest_crawl_fav_count      :integer
#  last_refreshed_from_twitter :datetime
#  followers_count             :integer
#  favorites_count             :integer
#  friends_count               :integer
#  statuses_count              :integer
#  created_at                  :datetime         not null
#  crawling_enabled            :boolean
#  latest_crawl_time           :datetime
#  next_crawl_time             :datetime
#  updated_at                  :datetime         not null
#

