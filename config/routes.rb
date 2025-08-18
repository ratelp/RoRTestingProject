Rails.application.routes.draw do
  devise_for :users
  resources :sales
  resources :posts, only: [:index]
  resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "about" => "pages#about"
  get "dashboard/index"

  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :show, :create]
    end
  end

  # A new route for a page with a form to create a post via the API
  resources :api_posts, only: [:new, :create], path: "api-posts"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
