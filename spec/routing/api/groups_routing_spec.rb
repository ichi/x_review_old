require "rails_helper"

RSpec.describe Api::GroupsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/groups").to route_to("api/groups#index")
    end

    it "routes to #show" do
      expect(:get => "/api/groups/1").to route_to("api/groups#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/groups").to route_to("api/groups#create")
    end

    it "routes to #update" do
      expect(:put => "/api/groups/1").to route_to("api/groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/groups/1").to route_to("api/groups#destroy", :id => "1")
    end

  end
end
