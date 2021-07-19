# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class ReferrerRewardCalculatorTest < ActiveSupport::TestCase
  def test_for_income
    FactoryBot.create :currency_rate, cur_from: Money::Currency.find(:RUB), cur_to: Money::Currency.find(:USD), rate_value: 1.0 / 60.0
    result = RewardCalculator
             .call(accrual_method: :income,
                   income_percentage: 10,
                   income_amount: 100.to_money(:rub),
                   profit_percentage: nil,
                   direction_rate: nil)
    assert_equal result, Money.new(17, 'USD')
  end

  def test_for_profit_percentage
    direction_rate = FactoryBot.create :gera_direction_rate

    # Create currency rate after direction rate to make snapshot fresh
    FactoryBot.create :currency_rate, cur_from: 'RUB', cur_to: 'USD', rate_value: 1.0 / 60.0

    result = RewardCalculator
             .call(accrual_method: :profit,
                   income_percentage: nil,
                   income_amount: 1000.to_money(:rub),
                   profit_percentage: 30,
                   direction_rate: direction_rate)

    assert_equal result, Money.new(1, 'USD')
  end
end
