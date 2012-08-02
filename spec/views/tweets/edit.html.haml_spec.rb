require 'spec_helper'

describe "tweets/edit" do
  before(:each) do
    @tweet = assign(:tweet, stub_model(Tweet))
  end

  it "renders the edit tweet form" do
    render

    rendered.should have_selector("form", :action => tweet_path(@tweet), :method => "post") do |form|
    end
  end
end
