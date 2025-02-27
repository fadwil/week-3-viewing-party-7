Rails.application.routes.draw do
  root 'welcome#index'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/users/:id/movies', to: 'movies#index', as: 'movies'
  get '/users/:user_id/movies/:id', to: 'movies#show', as: 'movie'

  resources :movies do
    resources :viewing_parties, only: [:new, :create]
  end

  get '/user_not_logged_in', to: 'movies#dummy_show', as: 'user_not_logged_in'

  get "/login", to: "users#login_form"
  post "/login", to: "users#login_user"
  get "/logout", to: "users#logout"

  get "/dashboard", to: "users#show"

  # resources :users, only: :show
end
