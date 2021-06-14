# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Запись в журнале расчетов обменных курсов
#
class RateCalculation < ApplicationRecord
  extend RateCalculationCommands
  include DirectionRateSerialization

  belongs_to :direction_rate, class_name: 'Gera::DirectionRate'

  monetize :suggested_income_amount_cents, as: :suggested_income_amount, allow_nil: true, with_model_currency: :income_amount_currency
  monetize :minimal_income_amount_cents, as: :minimal_income_amount, allow_nil: true, with_model_currency: :income_amount_currency
  monetize :maximal_income_amount_cents, as: :maximal_income_amount, allow_nil: true, with_model_currency: :income_amount_currency
  monetize :income_amount_cents, as: :income_amount
  monetize :outcome_amount_cents, as: :outcome_amount

  delegate :income_payment_system, :outcome_payment_system, :exchange_notification, to: :direction_rate

  enum direction: %i[from_income from_outcome], _prefix: true

  before_create do
    self.require_reserves = outcome_amount > outcome_payment_system.reserve_amount unless Rails.env.test?

    if income_amount < direction_rate.minimal_income_amount
      self.invalid_minimal_income_requirements = true
      self.minimal_income_amount = direction_rate.minimal_income_amount
    end

    if direction_rate.maximal_income_amount.present? && income_amount > direction_rate.maximal_income_amount
      self.invalid_maximal_income_requirements = true
      self.maximal_income_amount = direction_rate.maximal_income_amount
    end
  end

  def exchange_notification_message
    exchange_notification.render_message(money: income_amount) if exchange_notification.present?
  end
end
