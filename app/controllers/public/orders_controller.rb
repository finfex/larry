# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class OrdersController < ApplicationController
    def create
      order = OrderCreator.call build_rate_calculation
      redirect_to public_order_path(order), notice: 'Принята заявка на обмен. Ждём от Вас оплаты.'
    end

    def show
      render locals: { order: Order.find(params[:id]) }
    end

    private

    def build_rate_calculation
      calculator = RateCalculator.new(direction_rate)
      order_params.fetch(:request_direction).to_sym == :from_income ? calculator.build_from_income(income_amount) : calculator.build_from_outcome(outcome_amount)
    end

    def outcome_amount
      order_params.fetch(:outcome_amount).to_money direction_rate.outcome_currency
    end

    def income_amount
      order_params.fetch(:income_amount).to_money direction_rate.income_currency
    end

    def direction_rate
      @direction_rate ||= Gera::DirectionRate.find order_params.fetch(:direction_rate_id)
    end

    def order_params
      params
        .require(:order)
        .permit(:request_direction,
                # Не нужны
                # :income_payment_system_id,
                # :outcome_payment_system_id,
                :income_amount,
                :outcome_amount,
                :direction_rate_id)
    end
  end
end
