Myflix::Application.routes.draw do
  get 'home', to: 'videos#index'
  resources :videos, only: [:show] do
    resources :reviews, only: [:create]
    collection do
      get 'search'
    end
  end
  resources :users, only: [:create]
  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy] do
    collection do
      patch 'batch_update'
    end
  end
  get 'my_queue', to: 'queue_items#index'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  post 'sign_in', to: 'sessions#create'
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get 'register', to: 'users#new'
end
