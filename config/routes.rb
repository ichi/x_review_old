Rails.application.routes.draw do

  resources :groups

  resources :themes do
    resources :items, shallow: true do
      resources :reviews
    end
  end

  resources :users
end
