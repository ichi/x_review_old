Rails.application.routes.draw do
  resources :themes do
    resources :items, shallow: true
  end

  resources :users
end
