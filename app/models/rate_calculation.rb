# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Вычисляет курс в зависимости от направления и хранит в себе )
# Такой service-entity
#
class RateCalculation
  DIRECTIONS = %i[from_income from_outcome].freeze

  include Virtus.model

  MAX_INCOME_DIFF_TO_SUGGEST = Settings.max_incomde_diff_to_suggest.percents

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

  def build_from_income(income_amount)
    self.income_amount = income_amount
    self.request_direction = :from_income
    return self if direction_rate.nil?

    self.outcome_amount = direction_rate.exchange(income_amount)

    suggested_income_amount = direction_rate.reverse_exchange outcome_amount

    # Если есть более выгодный обмен, предлагаем клиенту
    self.suggested_income_amount = suggested_income_amount if income_amount.to_d.positive? &&
                                                              (income_amount.to_d - suggested_income_amount.to_d).as_percentage_of(income_amount.to_d) > MAX_INCOME_DIFF_TO_SUGGEST

    prepare

    self
  end

  def build_from_outcome(outcome_amount)
    self.outcome_amount = outcome_amount
    self.request_direction = :from_outcome
    return self if direction_rate.nil?

    self.income_amount = direction_rate.reverse_exchange(outcome_amount)

    prepare

    self
  end

  def build_order
    Order.new(
      income_amount: income_amount,
      income_payment_system: income_payment_system,
      outcome_payment_system: outcome_payment_system,
      outcome_amount: outcome_amount,
      direction_rate: direction_rate,
      request_direction: request_direction
    )
  end

  def valid?
    direction_rate.present? &&
      !invalid_minimal_income_requirements &&
      !invalid_maximal_income_requirements &&
      !require_reserving
  end

  private

  def prepare
    validate_reserves
    validate_minimal_income
    validate_maximal_income
  end

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
