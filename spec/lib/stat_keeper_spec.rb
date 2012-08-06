describe StatKeeper do
  it "should increase the fav count by one" do
    keeper = StatKeeper.new
    count = keeper.fav_count
    keeper.record_new_fav 
    keeper.fav_count.should == count + 1
  end
  it "should increase the author count by one" do
    keeper = StatKeeper.new
    count = keeper.author_count
    keeper.record_new_author 
    keeper.author_count.should == count + 1
  end
  it "should increase the tweet count by one" do
    keeper = StatKeeper.new
    count = keeper.tweet_count
    keeper.record_new_tweet 
    keeper.tweet_count.should == count + 1
  end
end
