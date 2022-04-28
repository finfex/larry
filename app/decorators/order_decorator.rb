# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class OrderDecorator < ApplicationDecorator
  COLUMNS = %i[created_at income_amount income_payment_system income_wallet outcome_payment_system outcome_amount outcome_wallet rate operator state
               based_income_amount user_income_address user_full_name user_email user_phone user_telegram city public_url credit_card_verification left_seconds expired?].freeze
  delegate_all

  def state
    h.present_order_status object.state
  end

  def credit_card_verification
    return 'Не требуется' unless object.require_verify_on_start?
    return 'Нет верификации карты' if object.credit_card_verification.nil?

    h.present_ccv_state object.credit_card_verification.state
  end

  def public_url
    h.link_to 'Публичная ссылка', h.public_order_url(object), target: '_blank'
  end

  def rate
    return '-' if object.rate_value.nil?

    # h.rate_humanized_description object.rate_value, object.income_currency, object.outcome_currency
    # h.humanized_currency_rate(object.rate_value, object.outcome_currency)
    h.humanized_rate_detailed object.rate_value
  end

  def user_confirmed_at
    return 'Не подтверждено' if object.user_confirmed_at.nil?

    I18n.l object.user_confirmed_at, format: :default
  end

  def outcome_amount
    h.humanized_money_with_currency object.outcome_amount
  end

  def based_income_amount
    h.humanized_money_with_currency object.based_income_amount
  end

  def user_income_address
    h.content_tag :pre, object.user_income_address
  end

  def income_amount
    h.humanized_money_with_currency object.income_amount
  end

  def income_payment_system
    h.present_payment_system object.income_payment_system
  end

  def outcome_payment_system
    h.present_payment_system object.outcome_payment_system
  end

  def income_wallet
    h.link_to object.income_wallet, h.operator_wallet_path(object.income_wallet)
  end

  def outcome_wallet
    h.link_to object.outcome_wallet, h.operator_wallet_path(object.outcome_wallet)
  end

  %i[user_telegram user_email user_phone user_full_name].each do |method|
    define_method method do
      object.send(method).presence || blank
    end
  end

  private

  def blank
    h.content_tag :i, I18n.t('helpers.not_specified')
  end
end
