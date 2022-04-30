# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper NotyFlash::ApplicationHelper
  helper Gera::CurrencyRateHelper
  include RailsWarden::Authentication
  include Referrer
  include HandleErrors
  layout 'simple'

  helper_method :current_admin_user, :current_user, :is_work_time?

  before_action :check_enabled

  private

  def check_enabled
    raise SiteUnknown unless SiteSettings.enabled
  end

  def check_work_time
    return if SiteSettings.is_work_time?
    raise HumanizedError, "У нас перерыв! Время работы с #{SiteSettings.work_start_hm} - #{SiteSettings.work_finish_hm}"
  end

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
