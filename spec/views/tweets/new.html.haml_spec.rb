require 'spec_helper'

describe "tweets/new" do
  before(:each) do
    assign(:tweet, stub_model(Tweet).as_new_record)
  end

  it "renders new tweet form" do
    render

    rendered.should have_selector("form", :action => tweets_path, :method => "post") do |form|
    end
  end
end
