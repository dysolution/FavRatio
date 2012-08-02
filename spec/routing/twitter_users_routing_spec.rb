require "spec_helper"

describe TwitterUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/twitter_users").should route_to("twitter_users#index")
    end

    it "routes to #new" do
      get("/twitter_users/new").should route_to("twitter_users#new")
    end

    it "routes to #show" do
      get("/twitter_users/1").should route_to("twitter_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/twitter_users/1/edit").should route_to("twitter_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/twitter_users").should route_to("twitter_users#create")
    end

    it "routes to #update" do
      put("/twitter_users/1").should route_to("twitter_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/twitter_users/1").should route_to("twitter_users#destroy", :id => "1")
    end

  end
end
