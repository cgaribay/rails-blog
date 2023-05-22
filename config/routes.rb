Rails.application.routes.draw do
  root "static_pages#home"

  post "sign_up", to: "users#create"
  get "sign_up", to: "users#new"

  post "login", to: "sessions#create"
  get "login", to: "sessions#new"
  delete "logout", to: "sessions#destroy"

  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token

  resources :articles do
    resources :comments
  end
end
