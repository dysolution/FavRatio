require 'spec_helper'

describe "tweets/show" do
  before(:each) do
    author = stub_model(TwitterUser, 
      avatar_url: "http://example.com/foo.jpg")
    @tweet = stub_model(Tweet, 
      author: author, 
      text: "Lorem ipsum dolor sit amet, consectetur 
      adipiscing elit. Suspendisse vestibulum sem mattis
      sapien blandit tempus. Sed velit ligula volutpat.")
  end

  it "renders attributes in <p>" do
    assign(:tweet, @tweet)
    render
  end

  it "displays the tweet content" do
    assign(:tweet, @tweet)
    render
    rendered.should have_selector("#text", 
                                  text: "Lorem ipsum")
  end

  it "properly renders unusual characters" do
    @tweet.text = "M & Ms"
    assign(:tweet, @tweet)
    render
    rendered.should have_selector("#text", text: "M & Ms")
  end

  it "displays the author's avatar" do
    render
    rendered.should have_selector(".avatar", 
      src: "http://example.com/foo.jpg")
  end

  # TODO: it "has a 'Share to Facebook' button"
end
