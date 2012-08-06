class UserRefresher

  def initialize(twitter_user, api=TwitterApi.new)
    @user_being_refreshed = twitter_user
    @api = api
  end

  def refresh
    get_new_info
    overwrite_attributes
  end

  private

  def get_new_info
    @fresh_info = @api.get_user_info(@user_being_refreshed.twitter_uid)
  end
  
  def overwrite_attributes
    user = TwitterUser.find(@user_being_refreshed.id)
    user.twitter_username = @fresh_info.screen_name
    user.avatar_url = @fresh_info.profile_image_url
    user.crawling_enabled = true
    user.last_refreshed_from_twitter = Time.now.utc
    user.save!
    user
  end

end
