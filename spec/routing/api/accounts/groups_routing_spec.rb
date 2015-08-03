require "rails_helper"

RSpec.describe Api::Account::GroupsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/account/groups").to route_to("api/account/groups#index")
    end

  end
end
