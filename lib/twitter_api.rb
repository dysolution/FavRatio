require 'twitter'

TWITTER_USER_WHOSE_FOLLOWERS_WILL_BE_CRAWLED = "FavRatio"

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

  def get_crawlable_users
    Twitter.follower_ids(TWITTER_USER_WHOSE_FOLLOWERS_WILL_BE_CRAWLED).collection
  end

end

