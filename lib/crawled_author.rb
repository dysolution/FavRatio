class CrawledAuthor

  def initialize(crawled_tweet)
    @twitter_uid = crawled_tweet.user.id.to_s
    @twitter_username = crawled_tweet.user.screen_name
    @avatar_url = crawled_tweet.user.profile_image_url
  end

  def favratio_user
    @user
  end

  def update_last_refreshed
    @user.last_refreshed_from_twitter = Time.now.utc
    @user.save
  end

  def exists?
    @user = TwitterUser.find_by_twitter_uid(@twitter_uid)
  end

  def create_user
    @user = TwitterUser.new(twitter_uid: @twitter_uid)
    @user.twitter_username = @twitter_username
    @user.avatar_url = @avatar_url
    @user.save
  end
end

