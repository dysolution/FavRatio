class UserCrawler

  require 'fav_provider'

  attr_reader :retrieved_favs,
    :new_users, :new_tweets, :new_favs
  attr_writer :fav_provider

  def initialize(twitter_user)
    @user_being_crawled = twitter_user
    @fav_provider = FavProvider.new(@user_being_crawled.twitter_uid)
    @retrieved_favs = []
    @new_users = []
    @new_tweets = []
    @new_favs = []
  end

  def get_favs_and_save_new_objects
    get_favs
    save_previously_unseen_objects
    adjust_crawl_interval
  end

  def get_favs
    @retrieved_favs = @fav_provider.get_favs
  end

  def save_previously_unseen_objects
    @retrieved_favs.each do |tweet|
      # TODO: there has to be a cleaner way to do this
      author = save_previously_unseen_author(tweet)
      tweet = save_previously_unseen_tweet(tweet, author)
      save_previously_unseen_fav(tweet)
    end
  end

  def adjust_crawl_interval
    @user_being_crawled.crawl_interval ||= 120
    @user_being_crawled.save
  end
  
  def save_previously_unseen_author(tweet)
    new_author = TwitterUser.
      find_or_initialize_by_twitter_uid(
        tweet.user.id.to_s)
    new_author.twitter_username = tweet.user.screen_name
    new_author.avatar_url = tweet.user.profile_image_url
    new_author.last_refreshed_from_twitter = Time.now.utc
    @new_users << new_author if new_author.save
    new_author
  end

  def save_previously_unseen_tweet(tweet, new_author)
    new_tweet = new_author.tweets.new(
      twitter_uid: tweet.id, text: tweet.text,
      timestamp: tweet.created_at)
    @new_tweets << new_tweet if new_tweet.save
    new_tweet
  end
  
  def save_previously_unseen_fav(tweet)
    new_fav = @user_being_crawled.favs.new(:tweet_id => tweet.id)
    @new_favs << new_fav if new_fav.save
  end
end
