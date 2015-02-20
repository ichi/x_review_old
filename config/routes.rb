Rails.application.routes.draw do
  resources :groups

  resources :themes do
    resources :items, shallow: true do
      resources :reviews
    end
  end

  resources :users

  namespace :api, format: :json do
    resources :themes, except: %i(new edit)
    # resources :groups
    #
    # resources :themes do
    #   resources :items, shallow: true do
    #     resources :reviews
    #   end
    # end
    #
    # resources :users
  end

  root to: 'pages#root'
end
