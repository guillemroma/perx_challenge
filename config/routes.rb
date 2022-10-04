Rails.application.routes.draw do
  devise_for :users, :path => 'u'
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: [:new, :create, :show, :index, :edit, :update, :destroy] do
    resources :transactions, only: [:index, :create, :new]
  end

  resources :dashboards, only: [:new]

  namespace :dashboard, only: [] do
    resources :users, only: [:show]
  end
end
