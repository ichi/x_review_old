require 'rails_helper'

RSpec.describe Api::ReviewsController, :type => :controller do
  let(:current_user){ create(:user) }
  let(:group){ create(:group, with_users: [current_user]) }
  let(:theme){ create(:theme, group: group) }
  let(:item){ create(:item, theme: theme) }
  let(:review){ create(:review, item: item) }
  let(:other_theme){ create(:theme) }
  let(:other_item){ create(:item, theme: other_theme) }
  let(:other_review){ create(:review, item: other_item) }
  let(:valid_attributes){ attributes_for(:review) }
  let(:invalid_attributes){ valid_attributes.merge(score: 0) }

  describe 'GET index' do
    before{ jget :index, item_id: item.to_param }

    it '@themeにthemeがアサインされている' do
      expect(assigns(:theme)).to eq theme
    end

    it '@itemにitemがアサインされている' do
      expect(assigns(:item)).to eq item
    end

    it '@reviewsに[review]がアサインされている' do
      expect(assigns(:reviews)).to eq [review]
    end
  end

  describe 'GET show' do
    before{ jget :show, id: review.to_param }

    it '@reviewにreviewがアサインされている' do
      expect(assigns(:review)).to eq review
    end
  end

  describe 'POST create' do
    context 'ログインしているとき' do
      login_user

      context 'editableなテーマのとき' do
        context 'with valid params' do
          before{ jpost :create, item_id: item.to_param, review: valid_attributes }

          it 'Reviewが1個増える' do
            expect{
              jpost :create, item_id: item.to_param, review: valid_attributes
            }.to change{ Review.count }.by 1
          end

          it '@reviewに新しいreviewがアサインされている' do
            expect(assigns(:review)).to be_a(Review).and be_persisted
          end

          it '@review.itemはitem' do
            expect(assigns(:review).item).to eq item
          end

          its(:response){ is_expected.to have_http_status :created }
        end

        context 'with invalid params (validate with model)' do
          before{ jpost :create, item_id: item.to_param, review: invalid_attributes }
          its(:response){ is_expected.to have_http_status :unprocessable_entity }
        end

        context 'with invalid params (validate with weak_parameters)' do
          before{ jpost :create, item_id: item.to_param, invalid: true }
          its(:response){ is_expected.to have_http_status :bad_request }
        end
      end

      context 'editableじゃないテーマのとき' do
        before{ jpost :create, item_id: other_item.to_param, review: valid_attributes }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていないとき' do
      before{ jpost :create, item_id: item.to_param, review: valid_attributes }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

  describe 'PATCH update' do
    let(:new_attributes){ attributes_for(:review) }

    context 'ログインしているとき' do
      login_user

      context 'editableなテーマのとき' do
        context 'with valid params' do
          before{ jpatch :update, id: review.to_param, review: new_attributes }

          it 'reviewがnew_attributesでアップデートされている' do
            review.reload
            expect(review).to have_attributes(new_attributes)
          end

          it '@reviewにreviewがアサインされている' do
            expect(assigns(:review)).to eq review
          end

          its(:response){ is_expected.to have_http_status :ok }
        end

        context 'with invalid params (validate with model)' do
          before{ jpatch :update, id: review.to_param, review: invalid_attributes }
          its(:response){ is_expected.to have_http_status :unprocessable_entity }
        end

        context 'with invalid params (validate with weak_parameters)' do
          before{ jpatch :update, id: review.to_param, invalid: true }
          its(:response){ is_expected.to have_http_status :bad_request }
        end
      end

      context 'editableじゃないテーマのとき' do
        before{ jpatch :update, id: other_review.to_param, review: new_attributes }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていないとき' do
      before{ jpatch :update, id: review.to_param, review: new_attributes }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

  describe 'DELETE destroy' do
    before{ review }

    context 'ログインしているとき' do
      login_user

      context 'editableなテーマのとき' do
        it 'Reviewが1個減ってる' do
          expect{
            jdelete :destroy, id: review.to_param
          }.to change{ Review.count }.by -1
        end

        it 'no_contentなステータスを返す' do
          jdelete :destroy, id: review.to_param
          expect(response).to have_http_status :no_content
        end
      end

      context 'editableじゃないテーマのとき' do
        before{ jdelete :destroy, id: other_review.to_param }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていないとき' do
      before{ jdelete :destroy, id: review.to_param }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end
end
