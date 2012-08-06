class CrawledAuthor

  attr_reader :favratio_user

  def initialize(crawled_tweet)
    @twitter_uid = crawled_tweet.user.id.to_s
    @twitter_username = crawled_tweet.user.screen_name
    @avatar_url = crawled_tweet.user.profile_image_url
  end

  def update_last_refreshed
    @favratio_user.last_refreshed_from_twitter = Time.now.utc
    @favratio_user.save
  end

  def exists?
    @favratio_user = TwitterUser.find_by_twitter_uid(@twitter_uid)
  end

  def create_favratio_user
    @favratio_user = TwitterUser.new(twitter_uid: @twitter_uid)
    @favratio_user.twitter_username = @twitter_username
    @favratio_user.avatar_url = @avatar_url
    @favratio_user.save
  end
end

