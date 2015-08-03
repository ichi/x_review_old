require 'rails_helper'

RSpec.describe Api::GroupsController, :type => :controller do
  let(:current_user){ create(:user) }
  let(:group){ create(:group, with_admins: [current_user]) }
  let(:other_group){ create(:group) }
  let(:valid_attributes){ attributes_for(:group) }
  let(:invalid_attributes){ valid_attributes.merge(name: '') }

  describe "GET index" do
    let(:group2){ create(:group) }
    before do
      group
      group2
    end
    before{ jget :index }

    it '@groupsに[group, group2]がアサインされている' do
      expect(assigns(:groups)).to match [group, group2]
    end
  end

  describe "GET show" do
    before{ jget :show, id: group.to_param }

    it '@groupにgroupがアサインされている' do
      expect(assigns(:group)).to eq group
    end
  end

  describe 'POST create' do
    context 'ログインしているとき' do
      login_user

      context 'valid params' do
        before{ jpost :create, group: valid_attributes }

        it 'Groupが1個増える' do
          expect{
            jpost :create, group: valid_attributes
          }.to change{ Group.count }.by 1
        end

        it '@groupに新しいgroupがアサインされている' do
          expect(assigns(:group)).to be_a(Group).and be_persisted
        end

        it '@group.usersにcurrent_userがadminとして入ってる' do
          expect(assigns(:group).users).to include current_user
          expect(assigns(:group).role_of(current_user)).to eq Role::ADMIN
        end

        its(:response){ is_expected.to have_http_status :created }
      end

      context 'invalid params (validate with model)' do
        before{ jpost :create, group: invalid_attributes  }
        its(:response){ is_expected.to have_http_status :unprocessable_entity }
      end

      context 'invalid params (validate with weak_parameters)' do
        before{ jpost :create, invalid: true  }
        its(:response){ is_expected.to have_http_status :bad_request }
      end
    end

    context 'ログインしていないとき' do
      before{ jpost :create, group: valid_attributes  }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

  describe 'PATCH update' do
    let(:new_attributes){ attributes_for(:group) }

    context 'ログインしているとき' do
      login_user

      context 'editableなテーマなとき' do
        context 'valid params' do
          before{ jpatch :update, id: group.to_param, group: new_attributes }

          it 'groupがnew_attributesでアップデートされている' do
            group.reload
            expect(group).to have_attributes(new_attributes)
          end

          it '@groupにgroupがアサインされている' do
            expect(assigns(:group)).to eq group
          end

          its(:response){ is_expected.to have_http_status :ok }
        end

        context 'invalid params (validate with model)' do
          before{ jpatch :update, id: group.to_param, group: invalid_attributes }
          its(:response){ is_expected.to have_http_status :unprocessable_entity }
        end

        context 'invalid params (validate with weak_parameters)' do
          before{ jpatch :update, id: group.to_param, invalid: true }
          its(:response){ is_expected.to have_http_status :bad_request }
        end
      end

      context 'editableなテーマじゃないとき' do
        before{ jpatch :update, id: other_group.to_param, group: new_attributes }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていないとき' do
      before{ jpatch :update, id: group.to_param, group: new_attributes }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

  describe 'DELETE destroy' do
    before{ group }

    context 'ログインしているとき' do
      login_user

      context 'editableなテーマなとき' do
        it 'Groupが1個減ってる' do
          expect{
            jdelete :destroy, id: group.to_param
          }.to change{ Group.count }.by -1
        end

        it 'no_contentなステータスを返す' do
          jdelete :destroy, id: group.to_param
          expect(response).to have_http_status :no_content
        end
      end

      context 'editableなテーマじゃないとき' do
        before{ jdelete :destroy, id: other_group.to_param }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていないとき' do
      before{ jdelete :destroy, id: group.to_param }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end
end
