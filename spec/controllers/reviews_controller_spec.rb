require 'rails_helper'

RSpec.describe ReviewsController, :type => :controller do
  let(:item){ create(:item) }
  let(:review){ create(:review, item: item) }

  let(:valid_attributes) {
    attributes_for(:review)
  }

  let(:invalid_attributes) {
    valid_attributes.merge(score: -1)
  }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all reviews as @reviews" do
      get :index, {item_id: item.to_param}, valid_session
      expect(assigns(:reviews)).to eq([review])
    end
  end

  describe "GET show" do
    it "assigns the requested review as @review" do
      get :show, {:id => review.to_param}, valid_session
      expect(assigns(:review)).to eq(review)
    end
  end

  describe "GET new" do
    it "assigns a new review as @review" do
      get :new, {item_id: item.to_param}, valid_session
      expect(assigns(:review)).to be_a_new(Review)
    end
  end

  describe "GET edit" do
    it "assigns the requested review as @review" do
      get :edit, {:id => review.to_param}, valid_session
      expect(assigns(:review)).to eq(review)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Review" do
        expect {
          post :create, {item_id: item.to_param, :review => valid_attributes}, valid_session
        }.to change(Review, :count).by(1)
      end

      it "assigns a newly created review as @review" do
        post :create, {item_id: item.to_param, :review => valid_attributes}, valid_session
        expect(assigns(:review)).to be_a(Review)
        expect(assigns(:review)).to be_persisted
      end

      it "redirects to the created review" do
        post :create, {item_id: item.to_param, :review => valid_attributes}, valid_session
        expect(response).to redirect_to(Review.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved review as @review" do
        post :create, {item_id: item.to_param, :review => invalid_attributes}, valid_session
        expect(assigns(:review)).to be_a_new(Review)
      end

      it "re-renders the 'new' template" do
        post :create, {item_id: item.to_param, :review => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        attributes_for(:review)
      }

      it "updates the requested review" do
        put :update, {:id => review.to_param, :review => new_attributes}, valid_session
        review.reload
        expect(review.attributes.symbolize_keys.slice(*new_attributes.keys)).to eq(new_attributes)
      end

      it "assigns the requested review as @review" do
        put :update, {:id => review.to_param, :review => valid_attributes}, valid_session
        expect(assigns(:review)).to eq(review)
      end

      it "redirects to the review" do
        put :update, {:id => review.to_param, :review => valid_attributes}, valid_session
        expect(response).to redirect_to(review)
      end
    end

    describe "with invalid params" do
      it "assigns the review as @review" do
        put :update, {:id => review.to_param, :review => invalid_attributes}, valid_session
        expect(assigns(:review)).to eq(review)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => review.to_param, :review => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before{ review }

    it "destroys the requested review" do
      expect {
        delete :destroy, {:id => review.to_param}, valid_session
      }.to change(Review, :count).by(-1)
    end

    it "redirects to the reviews list" do
      delete :destroy, {:id => review.to_param}, valid_session
      expect(response).to redirect_to(item_reviews_url(item))
    end
  end

end
