require "rails_helper"

RSpec.describe Api::ReviewsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/items/10/reviews").to route_to("api/reviews#index", item_id: '10')
    end

    it "routes to #show" do
      expect(:get => "/api/reviews/1").to route_to("api/reviews#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/items/10/reviews").to route_to("api/reviews#create", item_id: '10')
    end

    it "routes to #update" do
      expect(:put => "/api/reviews/1").to route_to("api/reviews#update",:id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/reviews/1").to route_to("api/reviews#destroy", :id => "1")
    end

  end
end
