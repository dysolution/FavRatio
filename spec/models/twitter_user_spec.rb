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
end

describe TwitterUser do
  before { @user = TwitterUser.new }
  subject { @user }

  it { should respond_to(:crawl) }

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

