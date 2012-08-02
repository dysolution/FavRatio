require 'twitter_user_provider'
require 'tweet_provider'
require 'rspec/mocks'

class FavProvider
  def initialize
    RSpec::Mocks::setup(self)
  end

  def get_favs(twitter_uid)
    Twitter.favorites(twitter_uid.to_i)
  end

  def mock_instance(tweets_to_return=20)
    fav_provider = double("fav_provider")
    tweets = []
    1.upto tweets_to_return do |n|
      author = TwitterUserProvider.new.mock_instance(n)
      tweets << TweetProvider.new(author).mock_instance(n)
    end
    fav_provider.stub(:get_favs).and_return(tweets)
    fav_provider
  end
end

