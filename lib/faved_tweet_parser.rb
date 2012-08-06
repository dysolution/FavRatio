require 'crawled_author'
require 'crawled_tweet'

class FavedTweetParser

  attr_reader :author_is_new, :tweet_is_new, :fav_is_new,
    :tweet
  
  def initialize(faved_tweet, user_being_crawled)
    @author_is_new = false
    @tweet_is_new = false
    @fav_is_new = false
    @faved_tweet = faved_tweet
    @author = find_or_create_author
    @user_being_crawled = user_being_crawled
  end

  def find_or_create_author
    author = CrawledAuthor.new(@faved_tweet)
    unless author.exists?
      @author_is_new = true
      author.create_favratio_user
    end
    author.update_last_refreshed
    author.favratio_user
  end
  
  def attribute_tweet_to_author
    crawled_tweet = CrawledTweet.new(@faved_tweet)
    unless crawled_tweet.exists?
      @tweet_is_new = true
      crawled_tweet.create_favratio_tweet
    end
    @tweet = crawled_tweet.favratio_tweet
    @author.tweets << @tweet
    @tweet
  end
  
  def find_or_create_fav
    unless Fav.find_by_tweet_id_and_faver_id(@tweet.id, @user_being_crawled.id)
      @fav_is_new = true
      new_fav = @user_being_crawled.favs.create(:tweet_id => @tweet.id)
    end
  end
end

