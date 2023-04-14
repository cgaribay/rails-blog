Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"
  root "articles#index"
  resources :articles do
    resources :comments
    end
end
