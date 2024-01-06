Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :dashboard
  end
  
  get '/dashboard/new' => 'admin/dashboard#new', as: :new_dashboard
  post '/dashboard' => 'admin/dashboard#create', as: :create_dashboard

  root 'home#index'

  # Defines the root path route ("/")
  # root "posts#index"
end
