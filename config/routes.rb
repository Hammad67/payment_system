Rails.application.routes.draw do
  resources :transactions, only: [:index]
  resources :features do
    resources :featureusages, except: [:destroy]
  end
  resources :plans
  resources :buyers
  resources :admins, only: [:index]
  resources :subscriptions, only: %i[new create show]
  devise_for :users, skip: [:registrations]
  resources :webhooks, only: [:create]
  root to: 'homes#index'
end
