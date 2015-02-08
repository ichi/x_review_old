require "rails_helper"

RSpec.describe ReviewsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/items/10/reviews").to route_to("reviews#index", item_id: '10')
    end

    it "routes to #new" do
      expect(:get => "/items/10/reviews/new").to route_to("reviews#new", item_id: '10')
    end

    it "routes to #show" do
      expect(:get => "/reviews/1").to route_to("reviews#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/reviews/1/edit").to route_to("reviews#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/items/10/reviews").to route_to("reviews#create", item_id: '10')
    end

    it "routes to #update" do
      expect(:put => "/reviews/1").to route_to("reviews#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reviews/1").to route_to("reviews#destroy", :id => "1")
    end

  end
end
