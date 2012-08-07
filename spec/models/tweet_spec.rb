require 'spec_helper'

describe Tweet do

  before do
    @author = create :author
    @tweet = create :tweet, author_id: @author.id
    @faver = create :faver
    @fav = @faver.favs.create tweet_id: @tweet.id
  end
  subject { @tweet }

  context "validations include" do
    describe "blank text" do
      before { @tweet.text = "" }
      it { should_not be_valid }
    end
    describe "text isn't present" do
      before { @tweet.text = nil }
      it { should_not be_valid }
    end
    describe "author isn't present" do
      before { @tweet.author_id = nil }
      it { should_not be_valid }
    end
    describe "text is too long" do
      before { @tweet.text = "a" * 141 }
      it { should_not be_valid }
    end
  end

  it "should find its author correctly" do
    @tweet.author.should == @author
  end

  it "should have the proper relationship to its favs" do
    @tweet.favs.should include @fav
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

