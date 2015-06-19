require 'rails_helper'

RSpec.describe "Api/Themes", :type => :request do
  let(:current_user){ create(:user) }
  let(:group){ create(:group) }
  let(:theme){ create(:theme, group: group, creator: current_user) }

  describe "GET /api/themes" do
    let(:other_theme){ create(:theme) }
    let(:themes){ [theme, other_theme] }

    before{ themes }
    before{ jget api_themes_path }
    subject{ response }

    it{ is_expected.to be_success }
    its(:status){ is_expected.to eq 200 }

    it "テーマ一覧を取得できる", autodoc: true do
      expect(response.body).to be_json_as([
        jsonize(theme.attributes).merge(
          'editable' => false,
          'group' => jsonize(group.attributes),
          'url' => api_theme_path(theme),
        ),
        jsonize(other_theme.attributes).merge(
          'editable' => false,
          'url' => api_theme_path(other_theme),
        )
      ])
    end
  end

  describe 'GET /api/themes/:id' do
    before{ jget api_theme_path(theme) }
    subject{ response }

    it{ is_expected.to be_success }
    its(:status){ is_expected.to eq 200 }

    it 'テーマを取得できる', autodoc: true do
      expect(response.body).to be_json_as(
        jsonize(theme.attributes).merge(
          'editable' => false,
          'group' => jsonize(group.attributes),
          'url' => api_theme_path(theme),
        )
      )
    end
  end
end
