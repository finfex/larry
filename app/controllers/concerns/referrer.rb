# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Referrer
  extend ActiveSupport::Concern

  included do
    helper_method :current_ref_token
    before_action do
      session[:ref_token] = params[:ref_token] if params[:ref_token].present?
    end
  end

  private

  def current_referrer
    return nil if current_ref_token.blank?

    @current_referrer ||= Partner.find_by(ref_token: current_ref_token)
  end

  def current_ref_token
    session[:ref_token]
  end
end
