require 'rails_helper'

RSpec.describe Api::ItemsController, :type => :controller do
  let(:current_user){ create(:user) }
  let(:group){ create(:group, with_users: [current_user]) }
  let(:theme){ create(:theme, group: group) }
  let(:item){ create(:item, theme: theme) }
  let(:other_theme){ create(:theme) }
  let(:other_item){ create(:item, theme: other_theme) }
  let(:valid_attributes){ attributes_for(:item, theme_id: theme.id) }
  let(:invalid_attributes){ valid_attributes.merge(name: '') }

  describe 'GET index' do
    before{ jget :index, theme_id: theme.to_param }

    it '@themeにthemeがアサインされている' do
      expect(assigns(:theme)).to eq theme
    end

    it '@itemsに[item]がアサインされている' do
      expect(assigns(:items)).to eq [item]
    end
  end

  describe 'GET show' do
    before{ jget :show, id: item.to_param }

    it '@itemにitemがアサインされている' do
      expect(assigns(:item)).to eq item
    end
  end

  describe 'POST create' do
    context 'ログインしているとき' do
      login_user

      context 'editableなテーマのとき' do
        context 'valid params' do
          before{ jpost :create, theme_id: theme.to_param, item: valid_attributes }
          
          it 'Itemが1個増える' do
            expect{
              jpost :create, theme_id: theme.to_param, item: valid_attributes
            }.to change{ Item.count }.by 1
          end

          it '@itemに新しいitemがアサインされている' do
            expect(assigns(:item)).to be_a(Item).and be_persisted
          end

          it '@item.themeはtheme' do
            expect(assigns(:item).theme).to eq theme
          end

          its(:response){ is_expected.to have_http_status :created }
        end

        context 'invalid params (validate with model)' do
          before{ jpost :create, theme_id: theme.to_param, item: invalid_attributes  }
          its(:response){ is_expected.to have_http_status :unprocessable_entity }
        end

        context 'invalid params (validate with weak_parameters)' do
          before{ jpost :create, theme_id: theme.to_param, invalid: true  }
          its(:response){ is_expected.to have_http_status :bad_request }
        end
      end

      context 'editableじゃないテーマのとき' do
        before{ jpost :create, theme_id: other_theme.to_param, item: valid_attributes  }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていないとき' do
      before{ jpost :create, theme_id: theme.to_param, item: valid_attributes  }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

  describe 'PATCH update' do
    let(:new_attributes){ attributes_for(:item) }

    context 'ログインしているとき' do
      login_user

      context 'editableなテーマなとき' do
        context 'valid params' do
          before{ jpatch :update, id: item.to_param, item: new_attributes }

          it 'itemがnew_attributesでアップデートされている' do
            item.reload
            expect(item).to have_attributes(new_attributes)
          end

          it '@itemにitemがアサインされている' do
            expect(assigns(:item)).to eq item
          end

          its(:response){ is_expected.to have_http_status :ok }
        end

        context 'invalid params (validate with model)' do
          before{ jpatch :update, id: item.to_param, item: invalid_attributes }
          its(:response){ is_expected.to have_http_status :unprocessable_entity }
        end

        context 'invalid params (validate with weak_parameters)' do
          before{ jpatch :update, id: item.to_param, invalid: true }
          its(:response){ is_expected.to have_http_status :bad_request }
        end
      end

      context 'editableなテーマじゃないとき' do
        before{ jpatch :update, theme_id: other_theme.to_param, id: other_item.to_param, item: new_attributes }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていないとき' do
      before{ jpatch :update, id: item.to_param, item: new_attributes }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

  describe 'DELETE destroy' do
    before{ item }

    context 'ログインしているとき' do
      login_user

      context 'editableなテーマなとき' do
        it 'Itemが1個減ってる' do
          expect{
            jdelete :destroy, id: item.to_param
          }.to change{ Item.count }.by -1
        end

        it 'no_contentなステータスを返す' do
          jdelete :destroy, id: item.to_param
          expect(response).to have_http_status :no_content
        end
      end

      context 'editableなテーマじゃないとき' do
        before{ jdelete :destroy, theme_id: other_theme.to_param, id: other_item.to_param }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていないとき' do
      before{ jdelete :destroy, id: item.to_param }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end
end
