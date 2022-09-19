# frozen_string_literal: true

Rails.application.routes.draw do
  resources :transactions, only: [:index]
  resources :features do
    resources :featureusages, except: [:destroy]
  end

  resources :plans
  resources :buyers
  resources :admins, only: %i[index]
  resources :subscriptions, only: %i[new create show update index]

  # namespace :api do
  #   namespace :v1 do
  devise_for :users,
             controllers: {
               sessions: 'api/v1/sessions',
               registrations: 'api/v1/registrations'
             }
  #   end
  # end
  resources :webhooks, only: %i[create]

  root to: 'homes#index'
end
