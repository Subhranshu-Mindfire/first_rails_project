Rails.application.routes.draw do
  resources :comments
  resources :posts
  resources :companies, path: :buisness
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users do
    collection do
      # get '/home', to: 'users#home'
      get "home"
      get "welcome"
      # get "new", as: "/signup"
      
    end
  end

  get "/signup", to: 'users#new'

  resources :roles

  resources :admins, only: [:index, :new, :create, :edit ]

  root "admins#index"
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  put '/confirm/:id/edit', to: 'registration#update'

  resources :confirmations, only: [:edit]

  patch '/confirmations/:id/confirm', to: 'confirmations#confirm', as: :confirm
  
  
end
