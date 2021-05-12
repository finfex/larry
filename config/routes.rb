# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'route_contraints'

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  scope module: :authentication do
    resources :sessions #, only: [:new, :create]
  end

  scope subdomain: 'operator', as: :operator, constraints: { subdomain: 'operator' } do
    scope constraints: RouteConstraints::AdminRequiredConstraint.new do
      mount Sidekiq::Web => 'sidekiq'
      mount Gera::Engine => '/gera'
      scope module: :operator do
        root to: 'dashboard#index'
        resources :wallets
        resources :wallet_activities
      end
    end
    match '*anything', to: 'application#not_found', via: %i[get post]
  end

  scope subdomain: '', as: :public, constraints: RouteConstraints::PublicConstraint.new do
    scope module: :public do
      root to: 'home#index'
      resources :pages, only: %i[index show]
    end
  end

  match '*anything', to: 'application#not_found', via: %i[get post]
end
