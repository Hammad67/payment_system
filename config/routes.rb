Rails.application.routes.draw do
  resources :transactions, only: [:index]
  resources :features do
    resources :featureusages, except: [:destroy]
  end

  resources :plans
  resources :buyers
  resources :admins, only: %i[index]
  resources :subscriptions, only: %i[new create show]
  devise_for :users, skip: %i[registrations]
  resources :webhooks, only: %i[create]

  root to: 'homes#index'
end
