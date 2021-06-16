# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class OrderDecorator < ApplicationDecorator
  delegate_all

  def rate
    return '-' if object.rate_value.nil?

    # h.rate_humanized_description object.rate_value, object.income_currency, object.outcome_currency
    # h.humanized_currency_rate(object.rate_value, object.outcome_currency)
    h.humanized_rate_detailed object.rate_value
  end

  def outcome_amount
    h.humanized_money_with_currency object.outcome_amount
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
end
