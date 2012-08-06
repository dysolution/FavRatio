class StatKeeper
  attr_reader :fav_count, :author_count, :tweet_count
  
  def initialize
    @fav_count, @author_count, @tweet_count = 0, 0, 0
  end

  def record_new_fav
    @fav_count += 1
  end

  def record_new_author
    @author_count += 1
  end

  def record_new_tweet
    @tweet_count += 1
  end
end


class UserCrawler

  attr_reader :retrieved_favs, :stat_keeper,
    :new_users, :new_tweets, :new_favs

  # The crawler can be tested in isolation from the
  # "live" Twitter API by specifying the
  # MockTwitterApi instead of the TwitterApi.
  def initialize(twitter_user, api=TwitterApi.new, num_favs=20)
    @user_being_crawled = twitter_user
    @api = api
    @retrieved_favs = []
    @stat_keeper = StatKeeper.new
    @num_favs = num_favs
  end

  def get_favs_and_save_new_objects
    get_favs
    save_previously_unseen_objects
    adjust_crawl_interval
  end

  def get_favs
    @retrieved_favs = @api.get_favs(@user_being_crawled.twitter_uid, num_favs=@num_favs)
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
    @stat_keeper.record_new_author if new_author.save
    new_author
  end

  def save_previously_unseen_tweet(tweet, new_author)
    new_tweet = new_author.tweets.new(
      twitter_uid: tweet.id, text: tweet.text,
      timestamp: tweet.created_at)
    @stat_keeper.record_new_tweet if new_tweet.save
    new_tweet
  end
  
  def save_previously_unseen_fav(tweet)
    new_fav = @user_being_crawled.favs.new(:tweet_id => tweet.id)
    @stat_keeper.record_new_fav if new_fav.save
  end
end
