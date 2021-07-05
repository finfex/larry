# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Calculate partner's reward
class RewardCalculator < ApplicationCommand
  def call(accrual_method:, income_percentage:, profit_percentage:, income_amount:, direction_rate:)
    reward_amount =
      case accrual_method.to_sym
      when :income
        Percent.new(income_percentage).percent_of income_amount
      when :profit
        Percent.new(profit_percentage).percent_of Money.new(direction_rate.get_profit_result(income_amount.to_d).profit_amount, income_amount.currency)
      else
        raise "Unknown accrual_method #{accrual_method}"
      end

    return reward_amount if Settings.rewards_currency.nil?

    reward_amount.exchange_to Settings.rewards_currency
  end
end
