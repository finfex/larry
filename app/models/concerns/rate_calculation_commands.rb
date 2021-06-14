# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module RateCalculationCommands
  # Максимально
  MAX_INCOME_DIFF_TO_SUGGEST = 5.percents

  def create_from_income!(direction_rate:, income_amount:)
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

    create! attrs
  end

  def create_from_outcome!(direction_rate:, outcome_amount:)
    create!(
      direction_rate: direction_rate,
      income_amount: direction_rate.reverse_exchange(outcome_amount),
      outcome_amount: outcome_amount,
      direction: :from_outcome
    )
  end
end
