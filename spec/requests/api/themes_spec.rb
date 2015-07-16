require 'rails_helper'

RSpec.describe "Api/Themes", :type => :request do
  let(:current_user){ create(:user) }
  let(:group){ create(:group) }
  let(:theme){ create(:theme, group: group, creator: current_user) }
  let(:other_theme){ create(:theme) }
  let(:valid_attributes){ attributes_for(:theme, group_id: group.id) }
  let(:invalid_attributes){ valid_attributes.merge(name: '') }

  describe "GET /api/themes" do
    before do
      theme
      other_theme
    end
    before{ jget api_themes_path }
    subject{ response }

    it{ is_expected.to be_success }
    its(:status){ is_expected.to eq 200 }

    it "テーマ一覧を取得する", autodoc: true do
      expect(response.body).to be_json_as([
        jsonize(theme.attributes.merge(
          editable: false,
          group: group.attributes,
          url: api_theme_path(theme),
        )),
        jsonize(other_theme.attributes.merge(
          editable: false,
          url: api_theme_path(other_theme),
        ))
      ])
    end
  end

  describe 'GET /api/themes/:id' do
    subject{ response }

    context 'valid params' do
      before{ jget api_theme_path(theme) }

      it{ is_expected.to be_success }
      it{ is_expected.to have_http_status(200) }

      it 'テーマを取得する', autodoc: true do
        expect(response.body).to be_json_as(
          jsonize(theme.attributes.merge(
            editable: false,
            group: group.attributes,
            url: api_theme_path(theme),
          ))
        )
      end
    end

    context 'invalid params' do
      before{ jget api_theme_path('invalid') }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:not_found) }
    end
  end

  describe 'POST /api/themes' do
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'valid params' do
        before{ jpost api_themes_path, theme: valid_attributes }

        it{ is_expected.to be_success }
        it{ is_expected.to have_http_status(:created) }

        let(:description) do
          'テーマを作成する。※要ログイン'
        end
        it 'テーマを作成する', autodoc: true do
          expect(response.body).to be_json_as(
            jsonize(valid_attributes.merge(
              group: group.attributes,
              creator_id: current_user.id,
              editable: true,
              url: String,
              id: Integer,
              created_at: json_timestamp_regexp,
              updated_at: json_timestamp_regexp,
            ))
          )
        end
      end

      context 'invalid params' do
        before{ jpost api_themes_path, theme: invalid_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:unprocessable_entity) }

        it 'エラーのjsonを返す' do
          expect(response.body).to be_json_as({
            name: Array
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jpost api_themes_path, theme: valid_attributes }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:forbidden) }

      it 'authentication errorのjsonを返す' do
        expect(response.body).to be_json_as({
          error: 'authentication error'
        })
      end
    end
  end

  describe 'PATCH /api/themes/:id' do
    let(:new_group){ create(:group) }
    let(:new_attributes){ attributes_for(:theme, group_id: new_group.id) }
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'テーマがeditableなとき' do
        context 'valid params' do
          before{ jpatch api_theme_path(theme), theme: new_attributes }

          it{ is_expected.to be_success }
          it{ is_expected.to have_http_status(200) }

          let(:description) do
            'テーマを更新する。※要ログイン'
          end
          it 'テーマを更新する', autodoc: true do
            expect(response.body).to be_json_as(
              jsonize(theme.attributes.merge(new_attributes).merge({
                editable: true,
                group: new_group.attributes,
                url: api_theme_path(theme),
                updated_at: json_timestamp_regexp,
              }))
            )
          end
        end

        context 'invalid params' do
          before{ jpatch api_theme_path(theme), theme: invalid_attributes }

          it{ is_expected.to_not be_success }
          it{ is_expected.to have_http_status(:unprocessable_entity) }

          it 'エラーのjsonを返す' do
            expect(response.body).to be_json_as({
              name: Array
            })
          end
        end
      end

      context 'テーマがeditableじゃないとき' do
        before{ jpatch api_theme_path(other_theme), theme: valid_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:forbidden) }

        it '編集できないよってエラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: 'You cannot edit this theme.'
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jpatch api_theme_path(theme), theme: valid_attributes }

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
        before{ jdelete api_theme_path(theme) }

        it{ is_expected.to be_success }
        it{ is_expected.to have_http_status(:no_content) }

        let(:description) do
          'テーマを削除する。※要ログイン'
        end
        it 'テーマを削除する', autodoc: true do
          expect(response.body).to be_empty
        end
      end

      context 'テーマがeditableじゃないとき' do
        before{ jdelete api_theme_path(other_theme), theme: valid_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:forbidden) }

        it '編集できないよってエラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: 'You cannot edit this theme.'
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jdelete api_theme_path(theme), theme: valid_attributes }

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
