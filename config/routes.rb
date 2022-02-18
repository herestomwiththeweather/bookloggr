Rails.application.routes.draw do
  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create', as: :login_post
  get '/logout' => 'sessions#destroy', as: :logout
  get '/callback' => 'sessions#callback', as: :callback

  resources :books do
    resources :logs, only: [:index, :create, :update, :destroy]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "books#home"
end
