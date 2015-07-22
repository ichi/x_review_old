require 'rails_helper'

RSpec.describe "Api/Reviews", :type => :request do
  let(:current_user){ create(:user) }
  let(:group){ create(:group) }
  let(:theme){ create(:theme, group: group, creator: current_user) }
  let(:item){ create(:item, theme: theme) }
  let(:review){ create(:review, item: item) }
  let(:other_theme){ create(:theme) }
  let(:other_item){ create(:item, theme: other_theme) }
  let(:other_review){ create(:review, item: other_item) }
  let(:valid_attributes){ attributes_for(:review) }
  let(:invalid_attributes){ valid_attributes.merge(score: 0) }

  describe "GET /api/items/:item_id/reviews" do
    before do
      review
      other_review
    end
    before{ jget api_item_reviews_path(item) }
    subject{ response }

    it{ is_expected.to be_success }
    its(:status){ is_expected.to eq 200 }

    it "レビュー一覧を取得する", autodoc: false do
      expect(response.body).to be_json_as([
        jsonize(review.attributes.merge(
          url: api_review_path(review),
        )),
      ])
    end
  end

  describe 'GET /api/reviews/:id' do
    subject{ response }

    context 'valid params' do
      before{ jget api_review_path(review) }

      it{ is_expected.to be_success }
      it{ is_expected.to have_http_status(200) }

      it 'レビューを取得する', autodoc: true do
        expect(response.body).to be_json_as(
          jsonize(review.attributes.merge(
            url: api_review_path(review),
          ))
        )
      end
    end

    context 'invalid params' do
      before{ jget api_review_path('invalid') }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:not_found) }
    end
  end

  describe 'POST /api/items/:item_id/reviews' do
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'valid params' do
        before{ jpost api_item_reviews_path(item), review: valid_attributes }

        it{ is_expected.to be_success }
        it{ is_expected.to have_http_status(:created) }

        let(:description) do
          'レビューを作成する。※要ログイン'
        end
        it 'レビューを作成する', autodoc: true do
          expect(response.body).to be_json_as(
            jsonize(valid_attributes.merge(
              id: Integer,
              item_id: item.id,
              url: String,
              created_at: json_timestamp_regexp,
              updated_at: json_timestamp_regexp,
            ))
          )
        end
      end

      context 'invalid params (validate with model)' do
        before{ jpost api_item_reviews_path(item), review: invalid_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:unprocessable_entity) }

        it 'エラーのjsonを返す' do
          expect(response.body).to be_json_as({
            score: Array
          })
        end
      end

      context 'invalid params (validate with weak_parameters)' do
        before{ jpost api_item_reviews_path(item), invalid: true }

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
      before{ jpost api_item_reviews_path(item), review: valid_attributes }

      it{ is_expected.to_not be_success }
      it{ is_expected.to have_http_status(:forbidden) }

      it 'authentication errorのjsonを返す' do
        expect(response.body).to be_json_as({
          error: 'authentication error'
        })
      end
    end
  end

  describe 'PATCH /api/reviews/:id' do
    let(:new_attributes){ attributes_for(:review) }
    subject{ response }

    context 'ログインしている時' do
      login_user

      context 'テーマがeditableなとき' do
        context 'valid params' do
          before{ jpatch api_review_path(review), review: new_attributes }

          it{ is_expected.to be_success }
          it{ is_expected.to have_http_status(200) }

          let(:description) do
            'レビューを更新する。※要ログイン'
          end
          it 'レビューを更新する', autodoc: true do
            expect(response.body).to be_json_as(
              jsonize(review.attributes.merge(new_attributes).merge({
                url: api_review_path(review),
                updated_at: json_timestamp_regexp,
              }))
            )
          end
        end

        context 'invalid params' do
          before{ jpatch api_review_path(review), review: invalid_attributes }

          it{ is_expected.to_not be_success }
          it{ is_expected.to have_http_status(:unprocessable_entity) }

          it 'エラーのjsonを返す' do
            expect(response.body).to be_json_as({
              score: Array
            })
          end
        end

        context 'invalid params (validate with weak_parameters)' do
          before{ jpatch api_review_path(review), invalid: true }

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
        before{ jpatch api_review_path(other_review), review: new_attributes }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:forbidden) }

        it '編集できないよってエラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: 'You cannot edit this review.'
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jpatch api_review_path(review), review: valid_attributes }

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
        before{ jdelete api_review_path(review) }

        it{ is_expected.to be_success }
        it{ is_expected.to have_http_status(:no_content) }

        let(:description) do
          'レビューを削除する。※要ログイン'
        end
        it 'レビューを削除する', autodoc: true do
          expect(response.body).to be_empty
        end
      end

      context 'テーマがeditableじゃないとき' do
        before{ jdelete api_review_path(other_review) }

        it{ is_expected.to_not be_success }
        it{ is_expected.to have_http_status(:forbidden) }

        it '編集できないよってエラーのjsonを返す' do
          expect(response.body).to be_json_as({
            error: 'You cannot edit this review.'
          })
        end
      end
    end

    context 'ログインしていない時' do
      before{ jdelete api_review_path(review) }

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
