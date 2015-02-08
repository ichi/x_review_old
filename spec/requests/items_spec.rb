require 'rails_helper'

RSpec.describe "Items", :type => :request do
  let(:theme){ create(:theme) }

  describe "GET /themes/1/items" do
    it "works! (now write some real specs)" do
      get theme_items_path(theme)
      expect(response).to have_http_status(200)
    end
  end
end
