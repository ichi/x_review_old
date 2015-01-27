require 'rails_helper'

RSpec.describe "Reviews", :type => :request do
  let(:item){ create(:item) }

  describe "GET /reviews" do
    it "works! (now write some real specs)" do
      get item_reviews_path(item)
      expect(response).to have_http_status(200)
    end
  end
end
