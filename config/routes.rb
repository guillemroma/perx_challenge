Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: [:new, :create, :show, :index, :update, :destroy]
  namespace :dashboard, only:[] do
    resources :users, only: [:show]
  end
  namespace :transactions, only: [] do
    resources :users, only: [:new, :create]
  end
end
