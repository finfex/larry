# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class RateCalculationTest < ActiveSupport::TestCase
  setup do
    @direction_rate = FactoryBot.create :gera_direction_rate
  end

  def test_build_from_income
    income_amount = Money.new(123, @direction_rate.income_currency)
    rate_calculation = RateCalculation
                       .new(direction_rate: @direction_rate)
                       .build_from_income(income_amount)

    assert_equal rate_calculation.request_direction, :from_income
    assert_equal rate_calculation.outcome_amount, Money.new(6642, @direction_rate.outcome_currency)
  end
end
