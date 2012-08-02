require 'spec_helper'

describe "tweets/show" do
  before(:each) do
    @tweet = assign(:tweet, stub_model(Tweet))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

describe "tweets/show" do
  it "displays the tweet content" do
  assign(:tweet, stub_model(Tweet,
    :text => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vestibulum sem mattis sapien blandit tempus. Sed velit ligula volutpat."
  ))
  render
  rendered.should have_selector("#text", text: "Lorem ipsum")
  end
end
