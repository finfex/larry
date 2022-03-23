# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class UserOrderDecorator < OrderDecorator
  def user_email
    secure object.user_email
  end

  def user_full_name
    return I18n.t('helpers.not_specified') if object.user_full_name.blank?
    secure object.user_full_name
  end

  def user_income_address
    h.content_tag :code do
      object.user_income_address
    end
  end

  def self.decorated_class
    Order
  end

  private

  def secure(string)
    return if string.blank?
    return '***' if string.length < 5

    string.slice(0, 2) + ' *** ' + string.slice(-2, 2)
  end
end
