# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper NotyFlash::ApplicationHelper
  helper Gera::CurrencyRateHelper
  include RailsWarden::Authentication
  include Referrer
  include HandleErrors
  layout 'simple'

  helper_method :current_admin_user, :current_user

  private

  def unauthenticated!
    throw(:warden, scope: :default, redirect_url: request.url)
  end

  def current_user
    user
  end

  def current_admin_user
    user :admin_user
  end
end
