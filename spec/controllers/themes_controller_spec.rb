require 'rails_helper'

RSpec.describe ThemesController, :type => :controller do
  let(:theme){ create(:theme) }

  let(:valid_attributes) {
    attributes_for(:theme)
  }

  let(:invalid_attributes) {
    valid_attributes.merge(name: '')
  }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all themes as @themes" do
      get :index, {}, valid_session
      expect(assigns(:themes)).to eq([theme])
    end
  end

  describe "GET show" do
    it "assigns the requested theme as @theme" do
      get :show, {:id => theme.to_param}, valid_session
      expect(assigns(:theme)).to eq(theme)
    end
  end

  describe "GET new" do
    it "assigns a new theme as @theme" do
      get :new, {}, valid_session
      expect(assigns(:theme)).to be_a_new(Theme)
    end
  end

  describe "GET edit" do
    it "assigns the requested theme as @theme" do
      get :edit, {:id => theme.to_param}, valid_session
      expect(assigns(:theme)).to eq(theme)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Theme" do
        expect {
          post :create, {:theme => valid_attributes}, valid_session
        }.to change(Theme, :count).by(1)
      end

      it "assigns a newly created theme as @theme" do
        post :create, {:theme => valid_attributes}, valid_session
        expect(assigns(:theme)).to be_a(Theme)
        expect(assigns(:theme)).to be_persisted
      end

      it "redirects to the created theme" do
        post :create, {:theme => valid_attributes}, valid_session
        expect(response).to redirect_to(Theme.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved theme as @theme" do
        post :create, {:theme => invalid_attributes}, valid_session
        expect(assigns(:theme)).to be_a_new(Theme)
      end

      it "re-renders the 'new' template" do
        post :create, {:theme => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        attributes_for(:theme)
      }

      it "updates the requested theme" do
        put :update, {:id => theme.to_param, :theme => new_attributes}, valid_session
        theme.reload
        expect(theme.attributes.symbolize_keys.slice(*new_attributes.keys)).to eq(new_attributes)
      end

      it "assigns the requested theme as @theme" do
        put :update, {:id => theme.to_param, :theme => valid_attributes}, valid_session
        expect(assigns(:theme)).to eq(theme)
      end

      it "redirects to the theme" do
        put :update, {:id => theme.to_param, :theme => valid_attributes}, valid_session
        expect(response).to redirect_to(theme)
      end
    end

    describe "with invalid params" do
      it "assigns the theme as @theme" do
        put :update, {:id => theme.to_param, :theme => invalid_attributes}, valid_session
        expect(assigns(:theme)).to eq(theme)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => theme.to_param, :theme => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before{ theme }

    it "destroys the requested theme" do
      expect {
        delete :destroy, {:id => theme.to_param}, valid_session
      }.to change(Theme, :count).by(-1)
    end

    it "redirects to the themes list" do
      delete :destroy, {:id => theme.to_param}, valid_session
      expect(response).to redirect_to(themes_url)
    end
  end

end
