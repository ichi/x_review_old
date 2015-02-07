require 'rails_helper'

RSpec.describe ItemsController, :type => :controller do
  let(:theme){ create(:theme) }
  let(:item){ create(:item, theme: theme) }

  let(:valid_attributes) {
    attributes_for(:item)
  }

  let(:invalid_attributes) {
    valid_attributes.merge(name: '')
  }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all items as @items" do
      get :index, {theme_id: theme.to_param}, valid_session
      expect(assigns(:items)).to eq([item])
    end
  end

  describe "GET show" do
    it "assigns the requested item as @item" do
      get :show, {:id => item.to_param}, valid_session
      expect(assigns(:item)).to eq(item)
    end
  end

  describe "GET new" do
    it "assigns a new item as @item" do
      get :new, {theme_id: theme.to_param}, valid_session
      expect(assigns(:item)).to be_a_new(Item)
    end
  end

  describe "GET edit" do
    it "assigns the requested item as @item" do
      get :edit, {:id => item.to_param}, valid_session
      expect(assigns(:item)).to eq(item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Item" do
        expect {
          post :create, {theme_id: theme.to_param, :item => valid_attributes}, valid_session
        }.to change(Item, :count).by(1)
      end

      it "assigns a newly created item as @item" do
        post :create, {theme_id: theme.to_param, :item => valid_attributes}, valid_session
        expect(assigns(:item)).to be_a(Item)
        expect(assigns(:item)).to be_persisted
      end

      it "redirects to the created item" do
        post :create, {theme_id: theme.to_param, :item => valid_attributes}, valid_session
        expect(response).to redirect_to(Item.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved item as @item" do
        post :create, {theme_id: theme.to_param, :item => invalid_attributes}, valid_session
        expect(assigns(:item)).to be_a_new(Item)
      end

      it "re-renders the 'new' template" do
        post :create, {theme_id: theme.to_param, :item => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        attributes_for(:item)
      }

      it "updates the requested item" do
        put :update, {:id => item.to_param, :item => new_attributes}, valid_session
        item.reload
        expect(item).to have_attributes(new_attributes)
      end

      it "assigns the requested item as @item" do
        put :update, {:id => item.to_param, :item => valid_attributes}, valid_session
        expect(assigns(:item)).to eq(item)
      end

      it "redirects to the item" do
        put :update, {:id => item.to_param, :item => valid_attributes}, valid_session
        expect(response).to redirect_to(item)
      end
    end

    describe "with invalid params" do
      it "assigns the item as @item" do
        put :update, {:id => item.to_param, :item => invalid_attributes}, valid_session
        expect(assigns(:item)).to eq(item)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => item.to_param, :item => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before{ item }

    it "destroys the requested item" do
      expect {
        delete :destroy, {:id => item.to_param}, valid_session
      }.to change(Item, :count).by(-1)
    end

    it "redirects to the items list" do
      delete :destroy, {:id => item.to_param}, valid_session
      expect(response).to redirect_to(theme_items_url(theme))
    end
  end

end
