require 'rails_helper'

RSpec.describe "Api/Account/Groups", :type => :request do
  let(:current_user){ create(:user) }
  let(:group){ create(:group, with_users: [current_user]) }
  let(:other_group){ create(:group) }

  describe 'GET /api/account/groups' do
    before do
      group
      other_group
    end
    subject{ response }

    context 'ログインしているとき' do
      login_user
      before{ jget api_account_groups_path }

      it{ is_expected.to be_success }
      its(:status){ is_expected.to eq 200 }

      let(:description) do
        '自分のグループ一覧を取得する。※要ログイン'
      end
      it "自分のグループ一覧を取得する", autodoc: true do
        expect(response.body).to be_json_as([
          jsonize(group.attributes.merge(
            editable: false,
            url: api_group_path(group)
          )),
        ])
      end
    end

    context 'ログインしていないとき' do
      before{ jget api_account_groups_path }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:forbidden) }

      it 'authentication errorのjsonを返す' do
        expect(response.body).to be_json_as({
          error: 'authentication error'
        })
      end
    end
  end

end
