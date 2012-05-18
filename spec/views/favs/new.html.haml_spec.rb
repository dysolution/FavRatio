require 'spec_helper'

describe "favs/new" do
  before(:each) do
    assign(:fav, stub_model(Fav,
      :tweet_id => 1
    ).as_new_record)
  end

  it "renders new fav form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => favs_path, :method => "post" do
      assert_select "input#fav_tweet_id", :name => "fav[tweet_id]"
    end
  end
end
