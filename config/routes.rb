Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  devise_scope :user do
    # get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
    get 'sign_in/:provider', :to => redirect('/users/auth/%{provider}'), :as => :sign_in
    get 'sign_out', :to => 'users/sessions#destroy', :as => :sign_out
  end

  resources :groups

  resources :themes do
    resources :items, shallow: true do
      resources :reviews
    end
  end

  resources :users

  namespace :api, format: :json do
    resources :themes, only: %i(index show create update destroy) do
      resources :items, only: %i(index show create update destroy), shallow: true do
        resources :reviews, only: %i(index show create update destroy), shallow: true
      end
    end

    # 自分の
    resource :account, only: [] do
      scope module: 'account' do
        resources :groups, only: %i(index)
      end
    end
  end

  root to: 'pages#root'
end
