# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class HomeController < ApplicationController
    helper Gera::ApplicationHelper
    helper Gera::DirectionRateHelper

    helper_method :income_payment_system, :outcome_payment_system,
                  :income_payment_systems, :outcome_payment_systems,
                  :income_amount,
                  :direction, :direction_rate, :final_reserves

    def index
      render locals: { order: rate_calculation.build_order, rate_calculation: rate_calculation }
    end

    private

    def exchange_rate; end
  end
end
