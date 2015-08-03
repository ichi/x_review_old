require 'rails_helper'

RSpec.describe Api::Account::GroupsController, :type => :controller do
  let(:current_user){ create(:user) }
  let(:group){ create(:group, with_users: [current_user]) }
  let(:other_group){ create(:group) }

  describe 'GET index' do
    before do
      group
      other_group
    end

    context 'ログインしているとき' do
      login_user
      before{ jget :index }

      it '@groupsに[group]がアサインされている' do
        expect(assigns(:groups)).to eq [group]
      end
    end

    context 'ログインしていないとき' do
      before{ jget :index }

      its(:response){ is_expected.to have_http_status(:forbidden) }
    end
  end
end
