require 'rails_helper'

RSpec.describe Api::User::GroupsController, :type => :controller do
  let(:current_user){ create(:user) }
  let(:group){ create(:group, with_users: [current_user]) }
  let(:other_group){ create(:group) }

  let(:valid_session) { {} }

  login_user

  describe "GET index" do
    before do
      group
      other_group
    end

    it "assigns all groups as @groups" do
      jget :index, {}, valid_session
      expect(assigns(:groups)).to eq([group])
    end
  end

  describe 'GET show' do
    it "assigns the requested group as @group" do
      jget :show, {:id => group.to_param}, valid_session
      expect(assigns(:group)).to eq(group)
    end

    context '自分のいないgroup' do
      it "ActiveRecord::RecordNotFoundがraiseされる" do
        expect{ jget :show, {:id => other_group.to_param}, valid_session }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

end
