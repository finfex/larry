# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class RateCalculationSerializationTest < ActiveSupport::TestCase
  setup do
    @direction_rate = FactoryBot.create :gera_direction_rate
    @income_amount = 123
  end

  def test_build_from_income
    rate_calculation = RateCalculation
                       .new(@direction_rate)
                       .build_from_income(@income_amount)

    o = Order.new
    o.rate_calculation = rate_calculation
    assert_nil o.rate_calculation, nil
    o.instance_variable_set '@rate_calculation', nil
    assert o.rate_calculation, rate_calculation
  end
end
