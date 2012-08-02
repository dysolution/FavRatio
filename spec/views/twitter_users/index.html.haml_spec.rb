require 'spec_helper'

describe "twitter_users/index" do
  before(:each) do
    assign(:twitter_users, [
      stub_model(TwitterUser),
      stub_model(TwitterUser)
    ])
  end

  it "renders a list of twitter_users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
