# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  get :logout, to: 'sessions#destroy'

  resources :sessions, only: %i[new create] do
    collection do
      delete :destroy
    end
  end

  scope subdomain: '', as: :public do
    scope module: :public do
      root to: 'home#index'
      resources :pages, only: %i[index show]
    end
  end

  namespace :operator do
    mount Sidekiq::Web => 'sidekiq'
    root to: 'dashboard#index'
    resources :wallets
  end
  mount Gera::Engine => '/gera'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
