require 'stat_keeper'

describe StatKeeper do
  before do
    @keeper = StatKeeper.new
  end

  it "should record a new fav" do
    @keeper.fav_count.should == 0
    @keeper.record_new_fav
    @keeper.fav_count.should == 1
  end

  it "should record a new tweet" do
    @keeper.tweet_count.should == 0
    @keeper.record_new_tweet
    @keeper.tweet_count.should == 1
  end

  it "should record a new author" do
    @keeper.author_count.should == 0
    @keeper.record_new_author
    @keeper.author_count.should == 1
  end
end
