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

  describe :crawl do
    before(:each) do
      @user = TwitterUser.create(twitter_uid:
        TwitterUser::FAVRATIO_TWITTER_USER_ID)
    end

    context "should not proceed" do
      it "without a valid twitter_uid" do
        @user.twitter_uid = nil
        @user.crawl.should be_false
      end
      it "if not enough time has passed" do
        @user.next_crawl_time = 5.minutes.from_now
        @user.crawl.should be_false
      end
      it "if crawling is disabled" do
        @user.crawling_enabled = false
        @user.crawl.should be_false
      end
    end

    context "when allowed to run" do
      pending "should stop hitting Twitter API for now" do
        before { @user.crawling_enabled = true }
        it "should know when its favs are stale" do
          @user.next_crawl_time = 23.minutes.ago
          @user.favs_are_stale.should be_true
        end
        it "should ensure the crawler waits to run again" do
          id = @user.id
          @user.latest_crawl_time = 5.hours.ago
          @user.crawl.should be_an(Array)
          @user = TwitterUser.find(id)
          @user.next_crawl_time.utc.should be > (Time.now + (@user.crawl_interval - 1).minutes).utc
        end

        context "but there is no new data to be found" do
          before { @user.crawl }
          it "should not try to save any users" do
            expect { @user.crawl }.should_not change(TwitterUser, :count)
          end
          it "should not try to save any tweets" do
            expect { @user.crawl }.should_not change(Tweet, :count)
          end
          it "should not try to save any favs" do
            expect { @user.crawl }.should_not change(Fav, :count)
          end
        end

        context "and there is new data to be found" do
          it "should record a new user" do
            TwitterUser.destroy_all
            expect do
              @user.crawl
            end.should change(TwitterUser, :count).by_at_least(1)
          end
          it "should record a new tweet" do
            Tweet.destroy_all
            expect do
              @user.crawl
            end.should change(Tweet, :count).by_at_least(1)
          end
          it "should record a new fav" do
            Fav.destroy_all
            expect do
              @user.crawl
            end.should change(Fav, :count).by_at_least(1)
          end
        end
      end
    end
  end

  describe :tweets do
    subject { @user.tweets }
    before { @user = TwitterUser.new }
    it { should be_an(Array) }
  end

  context "when bypassing Twitter" do
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
      @user_to_be_crawled = TwitterUser.create
      @fav_provider = double("fav_source")
      @fav_provider.stub(:get_favs) do
        [@tweet1, @tweet2, @tweet3]
      end
      @crawler = TwitterUser::UserCrawler.new(@user_to_be_crawled)
      @crawler.fav_provider = @fav_provider
    end

    it "should retrieve favs" do
      @fav_provider.get_favs.should have(3).entries
    end

    context "when there is previously unseen data" do

      it "should record fake authors" do
        @crawler.get_favs
        expect do
          @crawler.save_previously_unseen_objects
        end.should change(TwitterUser, :count).by(3)
      end

      it "should record fake tweets" do
        @crawler.get_favs
        expect do
          @crawler.save_previously_unseen_objects
        end.should change(Tweet, :count).by(3)
      end
      it "should record fake favs" do
        @crawler.get_favs
        expect do
          @crawler.save_previously_unseen_objects
        end.should change(Fav, :count).by(3)
      end
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

