require "rails_helper"

RSpec.describe Api::User::GroupsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/user/groups").to route_to("api/user/groups#index")
    end

    it "routes to #show" do
      expect(:get => "/api/user/groups/1").to route_to("api/user/groups#show", id: '1')
    end

  end
end
