require 'rails_helper'

RSpec.describe Api::ThemesController, :type => :controller do
  let(:current_user){ create(:user) }
  let(:group){ create(:group) }
  let(:theme){ create(:theme, group: group, creator: current_user) }
  let(:other_theme){ create(:theme) }
  let(:valid_attributes){ attributes_for(:theme, group_id: group.id) }
  let(:invalid_attributes){ valid_attributes.merge(name: '') }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all themes as @themes" do
      jget :index, {}, valid_session
      expect(assigns(:themes)).to eq([theme])
    end
  end

  describe "GET show" do
    it "assigns the requested theme as @theme" do
      jget :show, {:id => theme.to_param}, valid_session
      expect(assigns(:theme)).to eq(theme)
    end
  end

  describe "POST create" do
    context 'ログインしている' do
      login_user

      context "with valid params" do
        it "creates a new Theme" do
          expect {
            jpost :create, {:theme => valid_attributes}, valid_session
          }.to change(Theme, :count).by(1)
        end

        it "assigns a newly created theme as @theme" do
          jpost :create, {:theme => valid_attributes}, valid_session
          expect(assigns(:theme)).to be_a(Theme).and be_persisted
        end

        it "createdなstatusを返す" do
          jpost :create, {:theme => valid_attributes}, valid_session
          expect(response).to have_http_status :created
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved theme as @theme" do
          jpost :create, {:theme => invalid_attributes}, valid_session
          expect(assigns(:theme)).to be_a_new(Theme)
        end

        it 'unprocessable_entityなstatusを返す' do
          jpost :create, {:theme => invalid_attributes}, valid_session
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'ログインしていない' do
      before{ jpost :create, {:theme => valid_attributes}, valid_session }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

  describe "PUT update" do
    let(:new_attributes) { attributes_for(:theme) }

    context 'ログインしている' do
      login_user

      context 'themeがeditableなとき' do
        context "with valid params" do
          it "updates the requested theme" do
            jput :update, {:id => theme.to_param, :theme => new_attributes}, valid_session
            theme.reload
            expect(theme).to have_attributes(new_attributes)
          end

          it "assigns the requested theme as @theme" do
            jput :update, {:id => theme.to_param, :theme => new_attributes}, valid_session
            expect(assigns(:theme)).to eq(theme)
          end

          it 'okなstatusを返す' do
            jput :update, {:id => theme.to_param, :theme => new_attributes}, valid_session
            expect(response).to have_http_status :ok
          end
        end

        context "with invalid params" do
          it "assigns the theme as @theme" do
            jput :update, {:id => theme.to_param, :theme => invalid_attributes}, valid_session
            expect(assigns(:theme)).to eq(theme)
          end

          it 'unprocessable_entityなstatusを返す' do
            jput :update, {:id => theme.to_param, :theme => invalid_attributes}, valid_session
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context 'themeがeditableでないとき' do
        before{ jput :update, {:id => other_theme.to_param, :theme => new_attributes}, valid_session }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていない' do
      before{ jput :update, {:id => theme.to_param, :theme => new_attributes}, valid_session }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

  describe "DELETE destroy" do
    before{ theme }

    context 'ログインしている' do
      login_user

      context 'themeがeditableなとき' do
        it "destroys the requested theme" do
          expect {
            jdelete :destroy, {:id => theme.to_param}, valid_session
          }.to change(Theme, :count).by(-1)
        end

        it 'no_contentなstatusを返す' do
          jdelete :destroy, {:id => theme.to_param}, valid_session
          expect(response).to have_http_status :no_content
        end
      end

      context 'themeがeditableでないとき' do
        before{ jdelete :destroy, {:id => other_theme.to_param}, valid_session }
        its(:response){ is_expected.to have_http_status :forbidden }
      end
    end

    context 'ログインしていない' do
      before{ jdelete :destroy, {:id => theme.to_param}, valid_session }
      its(:response){ is_expected.to have_http_status :forbidden }
    end
  end

end
