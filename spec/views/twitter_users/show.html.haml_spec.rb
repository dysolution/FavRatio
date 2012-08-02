require 'spec_helper'

describe "twitter_users/show" do
  before(:each) do
    @twitter_user = assign(:twitter_user, stub_model(TwitterUser))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
