require 'stat_keeper'
require 'twitter_api'

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
    save_objects_if_new
    adjust_crawl_interval
  end

  def get_favs
    @retrieved_favs = @api.get_favs(@user_being_crawled.twitter_uid, num_favs=@num_favs)
  end

  def save_previously_unseen_tweet(tweet, new_author)
    new_tweet = new_author.tweets.new(
      twitter_uid: tweet.id, text: tweet.text,
      timestamp: tweet.created_at)
    #@stat_keeper.record_new_tweet if new_tweet.save
    new_tweet
  end

  def find_or_create_author(twitter_data)
    author = CrawledAuthor.new(twitter_data)
    unless author.exists?
      @stat_keeper.record_new_author
      author.create_user
    end
    author.update_last_refreshed
    author.favratio_user
  end

  class CrawledFavedTweet

    attr_reader :author_is_new, :tweet_is_new, :fav_is_new
    
    def initialize(faved_tweet, user_being_crawled)
      @faved_tweet = faved_tweet
      @author = find_or_create_author
      @author_is_new = false
      @tweet_is_new = false
      @fav_is_new = false
      @user_being_crawled = user_being_crawled
    end

    def find_or_create_author
      author = CrawledAuthor.new(@faved_tweet)
      unless author.exists?
        @author_is_new = true
        author.create_user
      end
      author.update_last_refreshed
      author.favratio_user
    end
    
    def attribute_tweet_to_author
      unless @tweet = Tweet.find_by_twitter_uid(@faved_tweet.id)
        @tweet_is_new = true
        @tweet = @author.tweets.create(
          twitter_uid: @faved_tweet.id,
          text: @faved_tweet.text,
          timestamp: @faved_tweet.created_at)
      end
    end
    
    def find_or_create_fav
      unless Fav.find_by_tweet_id_and_faver_id(@tweet.id, @user_being_crawled.id)
        @fav_is_new = true
        new_fav = @user_being_crawled.favs.create(:tweet_id => @tweet.id)
      end
    end
  end

  def save_objects_if_new
    @retrieved_favs.each do |faved_tweet|
      # TODO: use CrawledFavedTweet object to see if
      # it simplifies/abstracts things any better
      # than this.
      #
#      foo = CrawledFavedTweet.new(faved_tweet, @user_being_crawled)
#      foo.find_or_create_author
#      foo.attribute_tweet_to_author
#      foo.find_or_create_fav
#      @stat_keeper.record_new_author if foo.author_is_new
#      @stat_keeper.record_new_tweet if foo.tweet_is_new
#      @stat_keeper.record_new_fav if foo.fav_is_new
      record_fav_if_new(
        attribute_tweet_to_author(faved_tweet, 
          find_or_create_author(faved_tweet)))
    end
  end

  def attribute_tweet_to_author(twitter_data, author)
    unless tweet = Tweet.find_by_twitter_uid(twitter_data.id)
      @stat_keeper.record_new_tweet
      tweet = author.tweets.create(
        twitter_uid: twitter_data.id, text: twitter_data.text,
        timestamp: twitter_data.created_at)
    end
    tweet
  end

  def adjust_crawl_interval
    @user_being_crawled.crawl_interval ||= 120
    @user_being_crawled.save
  end
  
  def record_fav_if_new(tweet)
    unless Fav.find_by_tweet_id_and_faver_id(tweet.id, @user_being_crawled.id)
      @stat_keeper.record_new_fav
      new_fav = @user_being_crawled.favs.create(:tweet_id => tweet.id)
    end
  end
end
