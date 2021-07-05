# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Calculate referals reward
class ReferrerRewardCalculator < ApplicationCommand
  def call(accrual_method:, income_percentage:, profit_percentage:, income_amount:, direction_rate:)
    case accrual_method.to_sym
    when :income
      Percent.new(income_percentage).percent_of income_amount
    when :profit_percentage
      Percent.new(profit_percentage).percent_of direction_rate.get_profit_result(income_amount).profit_amount
    else
      raise 'WTF'
    end
  end
end
