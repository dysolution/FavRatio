class FavProvider
  def initialize(twitter_uid)
    @twitter_uid_int = twitter_uid.to_i
  end
  def get_favs
    Twitter.favorites(@twitter_uid_int)
  end
end
