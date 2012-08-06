require 'stat_keeper'
require 'twitter_api'
require 'faved_tweet_parser'

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

  def crawl
    get_favs
    parse_favs
    adjust_crawl_interval
  end

  def get_favs
    twitter_uid = @user_being_crawled.twitter_uid
    @retrieved_favs = @api.get_favs(twitter_uid, @num_favs)
  end

  private

  def parse_favs
    @retrieved_favs.each { |faved_tweet| save_only_new_objects(faved_tweet) }
  end

  def save_only_new_objects(faved_tweet)
    parser = FavedTweetParser.new(faved_tweet, @user_being_crawled)
    parser.find_or_create_author
    parser.attribute_tweet_to_author
    parser.find_or_create_fav
    update_stats(parser)
  end

  def update_stats(parser)
    @stat_keeper.record_new_author if parser.author_is_new
    @stat_keeper.record_new_tweet if parser.tweet_is_new
    @stat_keeper.record_new_fav if parser.fav_is_new
  end
    
  def adjust_crawl_interval
    @user_being_crawled.crawl_interval ||= 120
    @user_being_crawled.save
  end
end
