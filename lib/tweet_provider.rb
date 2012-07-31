require 'stub_helper'

class TweetProvider
  include StubHelper

  def initialize(author)
    @author = author
    RSpec::Mocks::setup(self)
  end

  def mock_instance(uid)
    tweet = mock("tweet_#{uid}")
    create_string_stubs(uid, tweet, %w(id text))
    tweet.stub(:user).and_return(@author)
    tweet.stub(:created_at).and_return(Time.now.utc)
    tweet
  end
end
