Rails.application.routes.draw do
  devise_for :users
  
  resources :stock_transactions, only: [:index, :create] do
    post 'buy', on: :member
    post 'sell', on: :member
  end

  namespace :admin do
    resources :dashboard do
      member do
        patch 'approve_user'
        patch 'reject_user'
      end
    end
  end
  
  get '/dashboard/new' => 'admin/dashboard#new', as: :new_dashboard
  post '/dashboard' => 'admin/dashboard#create', as: :create_dashboard

  get '/portfolio' => 'trader#index', as: :user_dashboard
  get '/pending' => 'pending#index', as: :pending
  root 'home#index'

  # Defines the root path route ("/")
  # root "posts#index"
end
