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

