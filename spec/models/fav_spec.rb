require 'spec_helper'

describe Fav do

  before(:each) do
    @author = TwitterUser.create!
    @tweet= Tweet.create!(text: 'foo', author_id: @author)
    @faver = TwitterUser.create!
    @fav = @faver.favs.create!(tweet_id: @tweet)
  end

  it "requires a faver" do
    Fav.new(tweet_id: @tweet).should_not be_valid
  end
  it "requires a tweet" do
    Fav.new(faver_id: @faver).should_not be_valid
  end
  it "properly distinguishes author and faver" do
    @fav.faver.should be_a(TwitterUser)
    @fav.tweet.author.id.should == @author.id
    @fav.faver.id.should == @faver.id
  end
  it "has a reference to the tweet that was faved" do
    @fav.tweet.should be_a(Tweet)
    @fav.tweet.id.should == @tweet.id
  end
  it "lets an author fav their own tweet" do
    expect do
      Fav.create!(tweet_id: @tweet,
                  faver_id: @fav.tweet.author)
    end.should change(Fav, :count).by(1)
  end

  context "for tweets with an existing Fav" do
    before(:each) do
      Fav.create!(tweet_id: 123, faver_id: 1)
    end
    it "should allow only one per user" do
      expect do
        Fav.create(tweet_id: 123, faver_id: 1)
      end.should_not change(Fav, :count)
    end
    it "should allow other users to fav it" do
      expect do
        Fav.create(tweet_id: 123, faver_id: 2)
      end.should change(Fav, :count).by(1)
    end
  end
end

# == Schema Information
#
# Table name: favs
#
#  id         :integer          not null, primary key
#  tweet_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faver_id   :integer
#

