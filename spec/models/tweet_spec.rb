require 'spec_helper'

describe Tweet do
  it "should have a relation to its author" do 
    Tweet.new.should respond_to(:author)
  end

  it "should find its author correctly" do
    user = TwitterUser.create!
    tweet = user.tweets.create!
    tweet.author.should == user
  end
end

