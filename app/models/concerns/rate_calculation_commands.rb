# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module RateCalculationCommands
  MAX_INCOME_DIFF_TO_SUGGEST = Settings.max_incomde_diff_to_suggest.percents

  def build_from_income(direction_rate:, income_amount:)
    attrs = {
      direction_rate: direction_rate,
      income_amount: income_amount,
      outcome_amount: direction_rate.exchange(income_amount),
      direction: :from_income
    }

    suggested_income_amount = direction_rate.reverse_exchange attrs[:outcome_amount]

    # Если есть более выгодный обмен, предлагаем клиенту
    if income_amount.to_d.positive? && (income_amount.to_d - suggested_income_amount.to_d).as_percentage_of(income_amount.to_d) > MAX_INCOME_DIFF_TO_SUGGEST
      attrs[:suggested_income_amount] =
        suggested_income_amount
    end

    build attrs
  end

  def build_from_outcome(direction_rate:, outcome_amount:)
    build(
      direction_rate: direction_rate,
      income_amount: direction_rate.reverse_exchange(outcome_amount),
      outcome_amount: outcome_amount,
      direction: :from_outcome
    )
  end

  def build(*args)
    new(args).tap do |_rc|
      self.require_reserving = outcome_amount > outcome_payment_system.reserve_amount unless Rails.env.test?

      if income_amount < direction_rate.minimal_income_amount
        self.invalid_minimal_income_requirements = true
        self.minimal_income_amount = direction_rate.minimal_income_amount
      end

      if direction_rate.maximal_income_amount.present? && income_amount > direction_rate.maximal_income_amount
        self.invalid_maximal_income_requirements = true
        self.maximal_income_amount = direction_rate.maximal_income_amount
      end
    end
    self
  end
end
