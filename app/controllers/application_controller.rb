# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper NotyFlash::ApplicationHelper
  helper Gera::CurrencyRateHelper
  include RailsWarden::Authentication
  layout 'simple'

  helper_method :current_admin_user

  private

  def current_admin_user
    user :admin_user
  end
end
