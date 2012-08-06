require 'spec_helper'
require 'user_refresher'
require 'mock_twitter_api'

describe UserRefresher do
  before(:each) do
    @user_with_stale_info = TwitterUser.create!(
      twitter_uid: 1234,
      twitter_username: "old_username",
      avatar_url: "http://example.com/old_avatar.jpg",
      crawling_enabled: false,
      last_refreshed_from_twitter: 5.days.ago)
    api = MockTwitterApi.new
    @refresher = UserRefresher.new(@user_with_stale_info, api)
    @refresher.refresh
    # make sure the changes persisted
    @updated_user = TwitterUser.find(@user_with_stale_info.id)
  end

  it "should make sure the user is crawlable" do
    @updated_user.crawling_enabled.should == true
  end
  it "should save the fresh info" do
    @updated_user.twitter_username.should match("current_username")
    @updated_user.avatar_url.should match("current_avatar")
  end
  it "should update the last_refreshed timestamp" do
    @updated_user.last_refreshed_from_twitter.utc.should be_within(1.minutes).of(Time.now.utc)
  end
end
