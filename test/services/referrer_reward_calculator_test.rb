# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class ReferrerRewardCalculatorTest < ActiveSupport::TestCase
  def test_for_income
    result = ReferrerRewardCalculator
             .call(accrual_method: :income,
                   income_percentage: 10,
                   income_amount: 100,
                   profit_percentage: nil,
                   direction_rate: nil)
    assert_equal result, 10
  end

  def test_for_profit_percentage
    direction_rate = FactoryBot.create :gera_direction_rate
    result = ReferrerRewardCalculator
             .call(accrual_method: :profit_percentage,
                   income_percentage: nil,
                   income_amount: 100,
                   profit_percentage: 1,
                   direction_rate: direction_rate)

    assert_equal result, 0.1
  end
end
