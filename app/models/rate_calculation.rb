# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Вычисляет курс в зависимости от направления и хранит в себе )
# Такой service-entity
#
class RateCalculation
  include MoneyHelper
  DIRECTIONS = %i[from_income from_outcome].freeze

  # include ActiveModel::Model
  include ActiveModel::Validations
  include Virtus.model

  attribute :id, String # Front generated UUID
  attribute :direction_rate, Gera::DirectionRate
  attribute :income_amount, Money
  attribute :outcome_amount, Money
  attribute :suggested_income_amount, Money

  attribute :require_reserving, Boolean, default: false

  # С какого направление пользователь спрашивает обмен с ввода или с вывода
  attribute :request_direction, Symbol

  delegate :minimal_income_amount, :maximal_income_amount, :income_payment_system, :outcome_payment_system, to: :direction_rate, allow_nil: true

  validates :direction_rate, presence: true
  validate :validate_minimal_income, if: :direction_rate
  validate :validate_maximal_income, if: :direction_rate
  validate :validate_reserves, if: :outcome_payment_system

  def self.load(attrs)
    new attrs
  end

  def build_order
    order = Order.new(
      income_amount: income_amount,
      income_payment_system: income_payment_system,
      outcome_payment_system: outcome_payment_system,
      outcome_amount: outcome_amount,
      direction_rate: direction_rate,
      request_direction: request_direction,
      rate_calculation: self
    )
    errors.each do |error|
      order.errors.add error.attribute, error.message
    end
    order
  end

  def dump
    as_json
  end

  private

  def validate_minimal_income
    return unless income_amount < minimal_income_amount

    errors.add :income_amount,
               "Минимальная допустима сумма для обмена в этом направлении #{humanized_money_with_currency minimal_income_amount}</span>".html_safe
  end

  def validate_maximal_income
    return unless maximal_income_amount.present? && income_amount > maximal_income_amount

    errors.add :income_amount,
               "Максимальная допустима сумма для обмена в этом направлении #{humanized_money_with_currency maximal_income_amount}</span>".html_safe
  end

  def validate_reserves
    if outcome_amount > outcome_payment_system.reserve_amount
      self.require_reserving = true
      errors.add :outcome_amount, "Недостаточно резервов, есть всего #{humanized_money_with_currency outcome_payment_system.reserve_amount}".html_safe
    else
      self.require_reserving = false
    end
  end
end
