require "rails_helper"

RSpec.describe Api::ItemsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/themes/10/items").to route_to("api/items#index", theme_id: '10')
    end

    it "routes to #show" do
      expect(:get => "/api/items/1").to route_to("api/items#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/themes/10/items").to route_to("api/items#create", theme_id: '10')
    end

    it "routes to #update" do
      expect(:put => "/api/items/1").to route_to("api/items#update",:id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/items/1").to route_to("api/items#destroy", :id => "1")
    end

  end
end
