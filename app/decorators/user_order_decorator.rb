# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class UserOrderDecorator < OrderDecorator
  COLUMNS = %i[created_at income_amount outcome_amount income_payment_system income_address outcome_payment_system rate user_confirmed_at user_income_address user_email user_full_name user_phone user_telegram state credit_card_verification]

  def user_email
    secure object.user_email
  end

  def user_full_name
    secure object.user_full_name
  end

  def user_phone
    secure object.user_phone
  end

  def user_telegram
    secure object.user_telegram
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
    return I18n.t('helpers.not_specified') if string.blank?
    return '***' if string.length < 5

    string.slice(0, 2) + ' *** ' + string.slice(-2, 2)
  end
end
