require 'twitter'

class TwitterApi
  # Wrapper for the library used to communicate with
  # Twitter's API.
  #
  def get_user_info(twitter_uid)
    Twitter.user(twitter_uid.to_i)
  end

  def get_favs(twitter_uid, count=20)
    Twitter.favorites(twitter_uid.to_i, options: { count: count })
  end
end

