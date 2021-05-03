# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  scope subdomain: '', as: :public do
    scope module: :public do
      root to: 'home#index'
    end
  end

  namespace :operator do
    mount Sidekiq::Web => 'sidekiq'
    mount Gera::Engine => '/'
    root to: 'dashboard#index'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
