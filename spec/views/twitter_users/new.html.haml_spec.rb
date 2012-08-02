require 'spec_helper'

describe "twitter_users/new" do
  before(:each) do
    assign(:twitter_user, stub_model(TwitterUser).as_new_record)
  end

  it "renders new twitter_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => twitter_users_path, :method => "post" do
    end
  end
end
