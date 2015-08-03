require 'rails_helper'

RSpec.describe "Api/Groups", :type => :request do
  let(:current_user){ create(:user) }
  let(:group){ create(:group, with_admins: [current_user]) }
  let(:other_group){ create(:group) }
  let(:valid_attributes){ attributes_for(:group) }
  let(:invalid_attributes){ valid_attributes.merge(name: '') }

  describe "GET /api/groups" do
    before do
      group
      other_group
    end
    before{ jget api_groups_path }
    subject{ response }

    it{ is_expected.to be_success }
    its(:status){ is_expected.to eq 200 }

    it "グループ一覧を取得する", autodoc: true do
      expect(response.body).to be_json_as([
        jsonize(group.attributes.merge(
          editable: false,
          url: api_group_path(group),
        )),
        jsonize(other_group.attributes.merge(
          editable: false,
          url: api_group_path(other_group),
        ))
      ])
    end
  end

  describe 'GET /api/groups/:id' do
    subject{ response }

    context 'valid params' do
      before{ jget api_group_path(group) }

      it{ is_expected.to be_success }
      it{ is_expected.to have_http_status(200) }

      it 'グループを取得する', autodoc: true do
        expect(response.body).to be_json_as(
          jsonize(group.attributes.merge(
            editable: false,
            url: api_group_path(group),
          ))
        )
      end
    end

    context 'invalid params' do
      before{ jget api_group_path('invalid') }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:not_found) }
    end
  end

  describe 'POST /api/groups' do
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'valid params' do
        before{ jpost api_groups_path, group: valid_attributes }

        it{ is_expected.to be_success }
        it{ is_expected.to have_http_status(:created) }

        let(:description) do
          'グループを作成する。※要ログイン'
        end
        it 'グループを作成する', autodoc: true do
          expect(response.body).to be_json_as(
            jsonize(valid_attributes.merge(
              editable: true,
              url: String,
              id: Integer,
              created_at: json_timestamp_regexp,
              updated_at: json_timestamp_regexp,
            ))
          )
        end
      end

      context 'invalid params (validate with model)' do
        before{ jpost api_groups_path, group: invalid_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:unprocessable_entity) }

        it 'エラーのjsonを返す' do
          expect(response.body).to be_json_as({
            name: Array
          })
        end
      end

      context 'invalid params (validate with weak_parameters)' do
        before{ jpost api_groups_path, {invalid: true} }

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
      before{ jpost api_groups_path, group: valid_attributes }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:forbidden) }

      it 'authentication errorのjsonを返す' do
        expect(response.body).to be_json_as({
          error: 'authentication error'
        })
      end
    end
  end

  describe 'PATCH /api/groups/:id' do
    let(:new_attributes){ attributes_for(:group) }
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'グループがeditableなとき' do
        context 'valid params' do
          before{ jpatch api_group_path(group), group: new_attributes }

          it{ is_expected.to be_success }
          it{ is_expected.to have_http_status(200) }

          let(:description) do
            'グループを更新する。※要ログイン'
          end
          it 'グループを更新する', autodoc: true do
            expect(response.body).to be_json_as(
              jsonize(group.attributes.merge(new_attributes).merge({
                editable: true,
                url: api_group_path(group),
                updated_at: json_timestamp_regexp,
              }))
            )
          end
        end

        context 'invalid params' do
          before{ jpatch api_group_path(group), group: invalid_attributes }

          it{ is_expected.to_not be_success }
          it{ is_expected.to have_http_status(:unprocessable_entity) }

          it 'エラーのjsonを返す' do
            expect(response.body).to be_json_as({
              name: Array
            })
          end
        end

        context 'invalid params (validate with weak_parameters)' do
          before{ jpatch api_group_path(group), {invalid: true} }

          it{ is_expected.to_not be_success }
          it{ is_expected.to have_http_status(:bad_request) }

          it 'エラーのjsonを返す' do
            expect(response.body).to be_json_as({
              error: String
            })
          end
        end
      end

      context 'グループがeditableじゃないとき' do
        before{ jpatch api_group_path(other_group), group: valid_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:forbidden) }

        it '編集できないよってエラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: 'You cannot edit this group.'
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jpatch api_group_path(group), group: valid_attributes }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:forbidden) }

      it 'authentication errorのjsonを返す' do
        expect(response.body).to be_json_as({
          error: 'authentication error'
        })
      end
    end
  end

  describe 'DELETE /api/groups/:id' do
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'グループがeditableなとき' do
        before{ jdelete api_group_path(group) }

        it{ is_expected.to be_success }
        it{ is_expected.to have_http_status(:no_content) }

        let(:description) do
          'グループを削除する。※要ログイン'
        end
        it 'グループを削除する', autodoc: true do
          expect(response.body).to be_empty
        end
      end

      context 'グループがeditableじゃないとき' do
        before{ jdelete api_group_path(other_group) }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:forbidden) }

        it '編集できないよってエラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: 'You cannot edit this group.'
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jdelete api_group_path(group) }

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
