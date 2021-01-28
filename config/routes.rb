Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products
  get "/sign-in", to: "sessions#new", as: :sign_in
  post "/sign-in", to: "sessions#create", as: :create_session
  get "/sign-out", to: "sessions#destroy", as: :sign_out
  root to: "dashboard#index"
end
