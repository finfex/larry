# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper NotyFlash::ApplicationHelper
  helper Gera::CurrencyRateHelper

  def self.ensure_authorization_performed
    # TODO: use sorcery
  end

  def current_user
    User.new
  end
end
