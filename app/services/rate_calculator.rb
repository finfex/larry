# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Calculate rate from income or outcome amount
# and returns RateCalculation
#
class RateCalculator
  MAX_INCOME_DIFF_TO_SUGGEST = Settings.max_incomde_diff_to_suggest.percents

  def initialize(direction_rate)
    @direction_rate = direction_rate
  end

  def build_from_income(income_amount)
    RateCalculation
      .new(
        direction_rate: direction_rate,
        income_amount: income_amount,
        request_direction: :from_income,
        outcome_amount: direction_rate.persisted? ? direction_rate.exchange(income_amount) : direction_rate.outcome_currency.zero_money
      )
      .tap { |rc| suggest_profitable_income rc }
  end

  def build_from_outcome(outcome_amount)
    RateCalculation
      .new(
        direction_rate: direction_rate,
        outcome_amount: outcome_amount,
        request_direction: :from_outcome,
        income_amount: direction_rate.persisted? ? direction_rate.reverse_exchange(outcome_amount) : direction_rate.income_currency.zero_money
      )
  end

  private

  attr_reader :direction_rate

  def suggest_profitable_income(rate_calculation)
    return unless direction_rate.persisted?

    suggested_income_amount = direction_rate.reverse_exchange rate_calculation.outcome_amount

    # Если есть более выгодный обмен, предлагаем клиенту
    if rate_calculation.income_amount.to_d.positive? &&
       (rate_calculation.income_amount.to_d - suggested_income_amount.to_d).as_percentage_of(rate_calculation.income_amount.to_d) > MAX_INCOME_DIFF_TO_SUGGEST
      rate_calculation.suggested_income_amount = suggested_income_amount
    end
  end
end
