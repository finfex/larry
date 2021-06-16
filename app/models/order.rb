# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Order < ApplicationRecord
  include DirectionRateSerialization
  include RateCalculationSerialization

  belongs_to :income_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :outcome_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :direction_rate, class_name: 'Gera::DirectionRate'

  monetize :income_amount_cents, as: :income_amount, allow_nil: false
  monetize :outcome_amount_cents, as: :outcome_amount, allow_nil: false

  enum request_direction: RateCalculation::DIRECTIONS

  def income_currency
    income_payment_system.currency
  end

  def outcome_currency
    outcome_payment_system.currency
  end

  def currency_pair
    Gera::CurrencyPair.new income_currency, outcome_currency
  end
end