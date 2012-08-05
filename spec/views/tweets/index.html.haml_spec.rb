require 'spec_helper'

describe "tweets/index" do
  before(:each) do
    assign(:tweets, [
      stub_model(Tweet, author: stub_model(TwitterUser, twitter_username: "foo")),
      stub_model(Tweet, author: stub_model(TwitterUser, twitter_username: "bar"))
    ])
  end

  it "renders a list of tweets" do
    render
  end
end
