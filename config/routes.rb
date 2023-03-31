Rails.application.routes.draw do
  resources :posts
  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create', as: :login_post
  get '/logout' => 'sessions#destroy', as: :logout
  get '/callback' => 'sessions#callback', as: :callback

  resources :books, shallow: true do
    resources :logs, only: [:show, :create, :edit, :update, :destroy] do
      member do
        get :translate
      end
    end
    resources :posts, only: [:create, :destroy]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "books#home"
end
