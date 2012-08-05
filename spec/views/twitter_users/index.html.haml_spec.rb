require 'spec_helper'

describe "twitter_users/index" do
  before(:each) do
    assign(:twitter_users, [
      stub_model(TwitterUser, twitter_username: "foo", avatar_url: "http://example.com/foo.jpg"),
      stub_model(TwitterUser, twitter_username: "bar")
    ])
  end

  it "renders a list of twitter_users" do
    render
  end

  it "shows their Twitter usernames" do
    render
    rendered.should have_selector('td', content: "bar")
  end

  it "shows their avatar" do
    render
    rendered.should have_selector("img.avatar", src: "http://example.com/foo.jpg")
  end

  it "should have a 'Crawl' link" do
    render
    rendered.should have_link('Crawl')
  end
end
