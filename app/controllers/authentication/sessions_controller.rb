# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Authentication
  class SessionsController < ApplicationController
    def new
      render locals: { redirect_url: redirect_url }
    end

    def create
      authenticate! scope: params.fetch(:scope)
      # It's already redirecited in authenticate!
      # redirect_to params[:redirect_url].presence || welcome_url
    end

    def destroy
      logout!
      redirect_to public_root_url, notice: t('.logged_out')
    end
  end
end
