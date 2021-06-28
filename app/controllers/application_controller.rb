# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper NotyFlash::ApplicationHelper
  helper Gera::CurrencyRateHelper
  include RailsWarden::Authentication
  include Referrer
  layout 'simple'

  rescue_from Gera::DirectionRatesRepository::NoActualSnapshot, with: :rescue_humanized_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  helper_method :current_admin_user, :current_user

  private

  def rescue_humanized_error(exception)
    render :exception, locals: { exception: exception }
  end

  def unauthenticated!
    throw(:warden, scope: :default, redirect_url: request.url)
  end

  def not_found
    render :not_found, layout: 'simple'
  end

  def current_user
    user
  end

  def current_admin_user
    user :admin_user
  end
end
