require 'spec_helper'

describe Fav do

  before(:each) do
    #@author = TwitterUser.create!
    @tweet = create :tweet
    @author = @tweet.author
    @faver = create :twitter_user
    @fav = @faver.favs.create! tweet_id: @tweet.id
  end

  context "validations" do
    it "requires a faver" do
      build(:fav, faver_id: nil).should_not be_valid
    end

    it "requires a tweet" do
      build(:fav, tweet_id: nil).should_not be_valid
    end
  end

  it "properly distinguishes author and faver" do
    @fav.faver.should be_a TwitterUser
    @fav.tweet.author.id.should == @author.id
    @fav.faver.id.should == @faver.id
  end

  it "has a reference to the tweet that was faved" do
    @fav.tweet.should be_a Tweet
    @fav.tweet.id.should == @tweet.id
  end

  it "lets an author fav their own tweet" do
    expect do
      create :fav, tweet_id: @tweet.id,
                   faver_id: @fav.tweet.author.id
    end.should change(Fav, :count).by 1
  end

  context "for tweets with an existing Fav" do
    before(:each) do
      @tweet = create :tweet
      @faver = create :faver
      @other_faver = create :faver
      @tweet.favs.create faver_id: @faver.id
    end

    it "should allow only one per user" do
      expect do
        @tweet.favs.create faver_id: @faver.id
      end.should_not change Fav, :count
    end

    it "should allow other users to fav it" do
      expect do
        @tweet.favs.create! faver_id: @other_faver.id
      end.should change(Fav, :count).by 1
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

