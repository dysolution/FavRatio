require 'twitter'

class TwitterApi
  # Wrapper for the library used to communicate with
  # Twitter's API.
  #
  def get_user_info(twitter_uid)
    Twitter.user(twitter_uid.to_i)
  end

  def get_favs(twitter_uid, num_favs=20)
    Twitter.favorites(twitter_uid.to_i)
  end
end

