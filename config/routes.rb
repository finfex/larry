# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'route_contraints'

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  concern :archivable do
    member do
      put :archive
      put :restore
    end
  end

  scope module: :authentication do
    resource :session, only: %i[new create destroy]
    resource :user, only: %i[new create edit update]
    resources :password_resets, only: %i[new create edit update]
  end

  scope subdomain: 'operator', constraints: { subdomain: 'operator' } do
    scope constraints: RouteConstraints::AdminRequiredConstraint.new do
      mount Gera::Engine => 'gera'
      mount Sidekiq::Web => 'sidekiq'
      scope as: :operator do
        scope module: :operator do
          root to: 'orders#index'
          resources :orders, only: %i[index show] do
            member do
              put :change_operator
              put :accept
              put :cancel
              put :done
              put :income_confirm
            end
          end
          resources :users, only: %i[index show]
          resources :pages do
            concerns :archivable
          end
          resources :wallets do
            concerns :archivable
          end
          resources :wallet_activities
          resources :reserves, only: %(index)
          resources :payment_systems do
            concerns :archivable
          end
          resources :currencies do
            concerns :archivable
          end
        end
      end
      scope constraints: { formats: /html/ } do
        match '*anything', to: 'application#not_found', via: %i[get post]
      end
    end
  end

  scope subdomain: '', as: :public, constraints: RouteConstraints::PublicConstraint.new do
    scope module: :public do
      root to: 'orders#new'
      resource :profile, only: %i[show]
      resources :orders, only: %i[create show] do
        member do
          put :confirm
        end
      end
      constraints ->(request) { request.xhr? } do
        resources :rate_calculations, only: %i[create]
      end
      scope constraints: { formats: /html/ } do
        match '*path', to: 'pages#show', via: %i[get], as: :page
      end
    end
  end

  scope constraints: { formats: /html/ } do
    match '*anything', to: 'application#not_found', via: %i[get post]
  end
end
