# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

module Public
  class RateCalculationssControllerTest < ActionDispatch::IntegrationTest
    setup do
      @direction_rate = FactoryBot.create :gera_direction_rate
      # FactoryBot.create :direction_rate_snapshot
      # FactoryBot.create :gera_payment_system
      # FactoryBot.create :gera_payment_system
    end

    def test_create_from_income
      income_amount = 123
      post public_rate_calculations_url, xhr: true,
                                         params: { request_direction: :from_income, direction_rate_id: @direction_rate.id, income_amount: income_amount }
      assert_response :success
      result = JSON.parse response.body
      assert_equal result['outcome_amount'].to_d, income_amount * @direction_rate.rate_value
    end

    def test_create_from_outcome
      outcome_amount = 123
      post public_rate_calculations_url, xhr: true,
                                         params: { request_direction: :from_outcome, direction_rate_id: @direction_rate.id, outcome_amount: outcome_amount }
      assert_response :success
      result = JSON.parse response.body
      assert_equal result['income_amount'], (outcome_amount.to_d / @direction_rate.rate_value).round(2).to_money(:rub).to_s
    end
  end
end
