Rails.application.routes.draw do
  resources :transactions
  resources :features do
    resources :featureusages
  end
  resources :plans
  resources :buyers
  resources :admins
  resources :subscriptions
  devise_for :users
  resources :webhooks

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'homes#index'
end
