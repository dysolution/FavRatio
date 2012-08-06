class CrawledTweet

  attr_reader :favratio_tweet

  def initialize(crawled_tweet)
    @twitter_uid = crawled_tweet.id
    @text = crawled_tweet.text
    @timestamp = crawled_tweet.created_at
  end

  def exists?
    @favratio_tweet = Tweet.find_by_twitter_uid(@twitter_uid)
  end

  def create_favratio_tweet
    @favratio_tweet = Tweet.new(twitter_uid: @twitter_uid)
    @favratio_tweet.text = @text
    @favratio_tweet.timestamp = @timestamp
    @favratio_tweet.save
  end
end

