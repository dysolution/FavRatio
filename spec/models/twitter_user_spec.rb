require 'spec_helper'

describe TwitterUser do
  it "should have a 'crawl' method" do
    twitter_user = TwitterUser.new
    twitter_user.should respond_to(:crawl)
  end
end

