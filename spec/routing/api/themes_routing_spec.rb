require "rails_helper"

RSpec.describe Api::ThemesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/themes").to route_to("api/themes#index")
    end

    it "routes to #show" do
      expect(:get => "/api/themes/1").to route_to("api/themes#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/themes").to route_to("api/themes#create")
    end

    it "routes to #update" do
      expect(:put => "/api/themes/1").to route_to("api/themes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/themes/1").to route_to("api/themes#destroy", :id => "1")
    end

  end
end
