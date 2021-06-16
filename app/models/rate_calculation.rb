# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Вычисляет курс в зависимости от направления и хранит в себе )
# Такой service-entity
#
class RateCalculation
  DIRECTIONS = %i[from_income from_outcome].freeze

  include Virtus.model

  attribute :direction_rate, Gera::DirectionRate
  attribute :income_amount, Money
  attribute :outcome_amount, Money
  attribute :invalid_maximal_income_requirements, Boolean, default: false
  attribute :invalid_minimal_income_requirements, Boolean, default: false
  attribute :require_reserving, Boolean, default: false
  attribute :suggested_income_amount, Money
  attribute :minimal_income_amount, Money
  attribute :maximal_income_amount, Money

  # С какого направление пользователь спрашивает обмен с ввода или с вывода
  attribute :request_direction, Symbol

  delegate :income_payment_system, :outcome_payment_system, to: :direction_rate

  def build_order
    Order.new(
      income_amount: income_amount,
      income_payment_system: income_payment_system,
      outcome_payment_system: outcome_payment_system,
      outcome_amount: outcome_amount,
      direction_rate: direction_rate,
      request_direction: request_direction,
      rate_calculation: self
    )
  end

  def dump
    as_json
  end

  def valid?
    direction_rate.present? &&
      !invalid_minimal_income_requirements &&
      !invalid_maximal_income_requirements &&
      !require_reserving
  end

  def validate
    return self if direction_rate.nil?

    validate_reserves
    validate_minimal_income
    validate_maximal_income
    self
  end

  private

  def validate_minimal_income
    return unless income_amount < direction_rate.minimal_income_amount

    self.invalid_minimal_income_requirements = true
    self.minimal_income_amount = direction_rate.minimal_income_amount
  end

  def validate_maximal_income
    return unless direction_rate.maximal_income_amount.present? && income_amount > direction_rate.maximal_income_amount

    self.invalid_maximal_income_requirements = true
    self.maximal_income_amount = direction_rate.maximal_income_amount
  end

  def validate_reserves
    self.require_reserving = outcome_amount > outcome_payment_system.reserve_amount unless Rails.env.test?
  end
end
