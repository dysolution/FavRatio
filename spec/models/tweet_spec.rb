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

# == Schema Information
#
# Table name: tweets
#
#  id                :integer          not null, primary key
#  twitter_uid       :string(255)
#  text              :text
#  author_id         :integer
#  timestamp         :datetime
#  is_atreply        :boolean
#  fav_count         :integer
#  fav_weight        :float
#  favs_per_follower :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

