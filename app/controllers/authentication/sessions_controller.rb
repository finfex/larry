# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Authentication
  class SessionsController < ApplicationController
    helper_method :session_resource, :session_resoruce_class, :session_scope

    def new
      redirect_url = request.env['warden.options'].fetch(:redirect_url, request.url) unless request.original_url.include?('/session')
      render locals: { redirect_url: redirect_url }
    end

    def create
      authenticate! scope: params.fetch(:scope)
      redirect_to params[:redirect_url].presence || welcome_url
    end

    def destroy
      logout!
      redirect_to public_root_url, notice: t('.logged_out')
    end
  end
end
