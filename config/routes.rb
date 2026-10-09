Rails.application.routes.draw do
  resources :cities
  resources :vehicles
  resources :trips do
    resources :bookings, only: %i[ new create show ] do
      member do
        patch :pay
        patch :cancel
      end
    end
  end
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
end
