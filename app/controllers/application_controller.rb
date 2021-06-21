# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper NotyFlash::ApplicationHelper
  helper Gera::CurrencyRateHelper
  include RailsWarden::Authentication
  layout 'simple'

  rescue_from Gera::DirectionRatesRepository::NoActualSnapshot, with: :rescue_humanized_error

  helper_method :current_admin_user

  private

  def rescue_humanized_error(exception)
    render :exception, locals: { exception: exception }
  end

  def current_admin_user
    user :admin_user
  end
end
