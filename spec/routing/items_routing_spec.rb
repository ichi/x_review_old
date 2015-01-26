require "rails_helper"

RSpec.describe ItemsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/themes/10/items").to route_to("items#index", theme_id: '10')
    end

    it "routes to #new" do
      expect(:get => "/themes/10/items/new").to route_to("items#new", theme_id: '10')
    end

    it "routes to #show" do
      expect(:get => "/items/1").to route_to("items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/items/1/edit").to route_to("items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/themes/10/items").to route_to("items#create", theme_id: '10')
    end

    it "routes to #update" do
      expect(:put => "/items/1").to route_to("items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/items/1").to route_to("items#destroy", :id => "1")
    end

  end
end
