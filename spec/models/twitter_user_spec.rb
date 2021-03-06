require 'spec_helper'

describe "Twitter User manager" do

  before do
    create :twitter_user
    create :twitter_user
    create :twitter_user, crawling_enabled: true
  end

  it "should know which Twitter users to crawl" do
    TwitterUser.count.should == 3
    TwitterUser.crawlable.should have(1).entry
  end

  it "should be able to crawl all crawlable users" do
    TwitterUser.should respond_to :crawl_all
  end

  it "should crawl all crawlable users" do
    TwitterUser.crawl_all
  end
end

describe TwitterUser do
  before do
    @user = build :twitter_user
  end

  it "should not allow duplicates" do
    create :twitter_user, twitter_uid: "1234"
    build(:twitter_user, twitter_uid: "1234").should_not be_valid
  end

  context "when authoring a tweet" do
    before { @user.save! }

    it "can create the tweet externally" do
      tweet = create :tweet, author_id: @user.id
      tweet.author.id.should == @user.id
      @user.tweets.should include tweet
    end

    it "can create the tweet directly in the user's collection" do
      tweet = @user.tweets.create! text: 'bar'
      tweet.author.id.should == @user.id
      @user.tweets.should include tweet
    end
  end

  it "should provide an array of tweets it has authored" do
    @user.tweets.should be_an Array
  end

  it "should know when its favs are stale" do
    @user.next_crawl_time = 23.minutes.ago
    @user.favs_are_stale.should be_true
  end

  it "should make the crawler wait between crawls" do
    user = @user.save
    @user.prepare_for_next_crawl
    @user = TwitterUser.find user
    next_crawl_time = (Time.now +
                       (@user.crawl_interval - 1).minutes
                      ).utc
    @user.next_crawl_time.utc.should be > next_crawl_time
  end

  describe "should not crawl" do
    before do
      @user = create :twitter_user
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
#  created_at                  :datetime         not null
#  crawling_enabled            :boolean
#  latest_crawl_time           :datetime
#  next_crawl_time             :datetime
#  updated_at                  :datetime         not null
#

