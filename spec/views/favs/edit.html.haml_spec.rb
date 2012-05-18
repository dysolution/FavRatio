require 'spec_helper'

describe "favs/edit" do
  before(:each) do
    @fav = assign(:fav, stub_model(Fav,
      :tweet_id => 1
    ))
  end

  it "renders the edit fav form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => favs_path(@fav), :method => "post" do
      assert_select "input#fav_tweet_id", :name => "fav[tweet_id]"
    end
  end
end
