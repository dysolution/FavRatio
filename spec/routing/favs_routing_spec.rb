require "spec_helper"

describe FavsController do
  describe "routing" do

    it "routes to #index" do
      get("/favs").should route_to("favs#index")
    end

    it "routes to #new" do
      get("/favs/new").should route_to("favs#new")
    end

    it "routes to #show" do
      get("/favs/1").should route_to("favs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/favs/1/edit").should route_to("favs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/favs").should route_to("favs#create")
    end

    it "routes to #update" do
      put("/favs/1").should route_to("favs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/favs/1").should route_to("favs#destroy", :id => "1")
    end

  end
end
