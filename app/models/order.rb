# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Order < ApplicationRecord
  include DirectionRateSerialization

  belongs_to :income_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :outcome_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :direction_rate, class_name: 'Gera::DirectionRate'
  belongs_to :rate_calculation

  monetize :income_amount_cents, as: :income_amount, allow_nil: false
  monetize :outcome_amount_cents, as: :outcome_amount, allow_nil: false

  def income_currency
    income_payment_system.currency
  end

  def outcome_currency
    outcome_payment_system.currency
  end
end
