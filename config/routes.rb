Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  unless Rails.env.production?
    scope path: "/__cypress__", controller: "cypress" do
      post "force_login", action: "force_login"
    end
  end
  resources :products
  resources :suppliers
  get "/sign-in", to: "sessions#new", as: :sign_in
  post "/sign-in", to: "sessions#create", as: :create_session
  get "/sign-out", to: "sessions#destroy", as: :sign_out
  root to: "dashboard#index"
end
