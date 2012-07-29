require 'spec_helper'

describe "Twitter User management" do

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

  describe :crawl do
    before(:each) do
      @user = TwitterUser.create(twitter_uid:
        TwitterUser::FAVRATIO_TWITTER_USER_ID)
    end
    it "shouldn't proceed without a valid twitter_uid" do
      @user.twitter_uid = nil
      @user.crawl.should be_false
    end
    it "shouldn't proceed if not enough time has passed" do
      @user.next_crawl_time = 5.minutes.from_now
      @user.crawl.should be_false
    end
    it "shouldn't proceed if crawling is disabled" do
      @user.crawling_enabled = false
      @user.crawl.should be_false
    end
    it "should proceed if favs are stale and crawling is enabled" do
      @user.next_crawl_time = 2.hours.ago
      @user.crawling_enabled = true
      @user.crawl.should be_an(Array)
    end
    it "should set the right next crawl time afterward" do
      id = @user.id
      @user.crawling_enabled = true
      @user.latest_crawl_time = 5.hours.ago
      @user.crawl.should be_an(Array)
      @user = TwitterUser.find(id)
      @user.next_crawl_time.utc.should be > (Time.now + (@user.crawl_interval - 1).minutes).utc
    end
  end

  it "should know about tweets it has faved" do
    @user.tweets.should be_an(Array)
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

