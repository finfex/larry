# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class RateCalculationsController < ApplicationController
    def create
      request_direction = params.fetch('request_direction', 'from_income')

      direction_rate = Gera::DirectionRate.find params[:direction_rate_id]
      calculator = RateCalculator.new(direction_rate)

      rate_calculation = if request_direction == 'from_income'
                           calculator
                             .build_from_income(params[:income_amount].to_d.to_money(direction_rate.income_payment_system.currency))
                         else
                           calculator
                             .build_from_outcome(params[:outcome_amount].to_d.to_money(direction_rate.outcome_payment_system.currency))
                         end

      rate_calculation.id = params[:id]
      rate_calculation.validate
      render json: present(rate_calculation)
    end

    private

    def present(rate_calculation)
      {
        id: rate_calculation.id,
        request_direction: rate_calculation.request_direction,
        income_amount: rate_calculation.income_amount.to_s,
        outcome_amount: rate_calculation.outcome_amount.to_s,
        require_reserving: rate_calculation.require_reserving,
        suggested_income_amount: rate_calculation.suggested_income_amount.nil? ? nil : rate_calculation.suggested_income_amount.to_d,
        errors: rate_calculation.errors.as_json,
        rate_value: helpers.humanized_rate_text(rate_calculation.direction_rate.rate_value)
      }
    end
  end
end
