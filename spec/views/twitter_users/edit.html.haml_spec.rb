require 'spec_helper'

describe "twitter_users/edit" do
  before(:each) do
    @twitter_user = assign(:twitter_user, stub_model(TwitterUser))
  end

  it "renders the edit twitter_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => twitter_users_path(@twitter_user), :method => "post" do
    end
  end
end
