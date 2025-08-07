Rails.application.routes.draw do
  # Configure Devise routes with OAuth callbacks only if credentials are available
  oauth_providers = []
  oauth_providers << :google_oauth2 if ENV["GOOGLE_CLIENT_ID"].present? && ENV["GOOGLE_CLIENT_SECRET"].present?
  oauth_providers << :github if ENV["GITHUB_CLIENT_ID"].present? && ENV["GITHUB_CLIENT_SECRET"].present?

  if oauth_providers.any?
    devise_for :users, controllers: {
      omniauth_callbacks: "users/omniauth_callbacks"
    }
  else
    devise_for :users
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")·
  # root "posts#index"

  resources :products
  root "products#index"
end
