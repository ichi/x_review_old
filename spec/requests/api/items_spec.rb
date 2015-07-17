require 'rails_helper'

RSpec.describe "Api/Items", :type => :request do
  let(:current_user){ create(:user) }
  let(:group){ create(:group) }
  let(:theme){ create(:theme, group: group, creator: current_user) }
  let(:item){ create(:item, theme: theme) }
  let(:other_theme){ create(:theme) }
  let(:other_item){ create(:item, theme: other_theme) }
  let(:valid_attributes){ attributes_for(:item) }
  let(:invalid_attributes){ valid_attributes.merge(name: '') }

  describe "GET /api/themes/:theme_id/items" do
    before do
      item
      other_item
    end
    before{ jget api_theme_items_path(theme) }
    subject{ response }

    it{ is_expected.to be_success }
    its(:status){ is_expected.to eq 200 }

    it "アイテム一覧を取得する", autodoc: true do
      expect(response.body).to be_json_as([
        jsonize(item.attributes.merge(
          url: api_item_path(item),
        )),
      ])
    end
  end

  describe 'GET /api/items/:id' do
    subject{ response }

    context 'valid params' do
      before{ jget api_item_path(item) }

      it{ is_expected.to be_success }
      it{ is_expected.to have_http_status(200) }

      it 'アイテムを取得する', autodoc: true do
        expect(response.body).to be_json_as(
          jsonize(item.attributes.merge(
            url: api_item_path(item),
          ))
        )
      end
    end

    context 'invalid params' do
      before{ jget api_item_path('invalid') }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:not_found) }
    end
  end

  describe 'POST /api/themes/:theme_id/items' do
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'valid params' do
        before{ jpost api_theme_items_path(theme), item: valid_attributes }

        it{ is_expected.to be_success }
        it{ is_expected.to have_http_status(:created) }

        let(:description) do
          'アイテムを作成する。※要ログイン'
        end
        it 'アイテムを作成する', autodoc: true do
          expect(response.body).to be_json_as(
            jsonize(valid_attributes.merge(
              id: Integer,
              theme_id: theme.id,
              url: String,
              created_at: json_timestamp_regexp,
              updated_at: json_timestamp_regexp,
            ))
          )
        end
      end

      context 'invalid params (validate with model)' do
        before{ jpost api_theme_items_path(theme), item: invalid_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:unprocessable_entity) }

        it 'エラーのjsonを返す' do
          expect(response.body).to be_json_as({
            name: Array
          })
        end
      end

      context 'invalid params (validate with weak_parameters)' do
        before{ jpost api_theme_items_path(theme), invalid: true }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:bad_request) }

        it 'エラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: String
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jpost api_theme_items_path(theme), item: valid_attributes }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:forbidden) }

      it 'authentication errorのjsonを返す' do
        expect(response.body).to be_json_as({
          error: 'authentication error'
        })
      end
    end
  end

  describe 'PATCH /api/items/:id' do
    let(:new_attributes){ attributes_for(:item) }
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'テーマがeditableなとき' do
        context 'valid params' do
          before{ jpatch api_item_path(item), item: new_attributes }

          it{ is_expected.to be_success }
          it{ is_expected.to have_http_status(200) }

          let(:description) do
            'アイテムを更新する。※要ログイン'
          end
          it 'アイテムを更新する', autodoc: true do
            expect(response.body).to be_json_as(
              jsonize(item.attributes.merge(new_attributes).merge({
                url: api_item_path(item),
                updated_at: json_timestamp_regexp,
              }))
            )
          end
        end

        context 'invalid params' do
          before{ jpatch api_item_path(item), item: invalid_attributes }

          it{ is_expected.to_not be_success }
          it{ is_expected.to have_http_status(:unprocessable_entity) }

          it 'エラーのjsonを返す' do
            expect(response.body).to be_json_as({
              name: Array
            })
          end
        end

        context 'invalid params (validate with weak_parameters)' do
          before{ jpatch api_item_path(item), invalid: true }

          it{ is_expected.to_not be_success }
          it{ is_expected.to have_http_status(:bad_request) }

          it 'エラーのjsonを返す' do
            expect(response.body).to be_json_as({
              error: String
            })
          end
        end
      end

      context 'テーマがeditableじゃないとき' do
        before{ jpatch api_item_path(other_item), item: new_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:forbidden) }

        it '編集できないよってエラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: 'You cannot edit this item.'
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jpatch api_item_path(item), item: valid_attributes }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:forbidden) }

      it 'authentication errorのjsonを返す' do
        expect(response.body).to be_json_as({
          error: 'authentication error'
        })
      end
    end
  end

  describe 'DELETE /api/themes/:id' do
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'テーマがeditableなとき' do
        before{ jdelete api_item_path(item) }

        it{ is_expected.to be_success }
        it{ is_expected.to have_http_status(:no_content) }

        let(:description) do
          'アイテムを削除する。※要ログイン'
        end
        it 'アイテムを削除する', autodoc: true do
          expect(response.body).to be_empty
        end
      end

      context 'テーマがeditableじゃないとき' do
        before{ jdelete api_item_path(other_item) }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:forbidden) }

        it '編集できないよってエラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: 'You cannot edit this item.'
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jdelete api_item_path(item) }

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
