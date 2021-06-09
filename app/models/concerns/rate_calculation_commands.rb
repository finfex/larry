# frozen_string_literal: true

module RateCalculationCommands
  # Максимально
  MAX_INCOME_DIFF_TO_SUGGEST = 5.percents

  def create_from_income!(direction_rate:, income_money:)
    attrs = {
      direction_rate: direction_rate,
      income_amount: income_money,
      outcome_amount: direction_rate.exchange(income_money),
      direction: :from_income
    }

    suggested_income_amount = direction_rate.reverse_exchange attrs[:outcome_amount]

    # Если есть более выгодный обмен, предлагаем клиенту
    attrs[:suggested_income_amount] = suggested_income_amount if income_money.to_d.positive? && (income_money.to_d - suggested_income_amount.to_d).as_percentage_of(income_money.to_d) > MAX_INCOME_DIFF_TO_SUGGEST

    create! attrs
  end

  def create_from_outcome!(direction_rate:, outcome_money:)
    create!(
      direction_rate: direction_rate,
      income_amount: direction_rate.reverse_exchange(outcome_money),
      outcome_amount: outcome_money,
      direction: :from_outcome
    )
  end
end
