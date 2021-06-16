# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class OrdersController < ApplicationController
    helper Gera::ApplicationHelper
    helper Gera::DirectionRateHelper

    def new
      income_payment_system = income_payment_systems.find_by(id: params[:cur_from]) if params[:cur_from]
      income_payment_system ||= income_payment_systems.first

      outcome_payment_system = outcome_payment_systems.find_by(id: params[:cur_to]) if params[:cur_to]
      outcome_payment_system ||= outcome_payment_systems.where.not(id: income_payment_system).first
      # Подбор платежной системы из доступных в exchange_rate и для которых есть direction_rate
      #
      # exchange_rate.outcome_payment_system
      # Gera::ExchangeRate.available.where(payment_system_from_id: income_payment_system.id).take
      #
      direction = Gera::Direction.new(ps_from: income_payment_system, ps_to: outcome_payment_system).freeze
      direction_rate = direction.direction_rate

      income_amount = [
        params[:income_amount].to_f.to_money(income_payment_system.currency),
        income_payment_system.minimal_income_amount
      ].max

      outcome_amount = direction_rate.nil? ? outcome_payment_system.currency.zero_money : direction_rate.exchange(income_amount)
      rate_calculation = build_rate_calculation direction_rate, income_amount, outcome_amount, params.fetch('request_direction', 'from_income')

      render locals: { order: rate_calculation.build_order, rate_calculation: rate_calculation }
    end

    def create
      direction_rate = Gera::DirectionRate.find order_params.fetch(:direction_rate_id)
      outcome_amount = order_params.fetch(:outcome_amount).to_money direction_rate.outcome_currency
      income_amount = order_params.fetch(:income_amount).to_money direction_rate.income_currency
      rate_calculation = build_rate_calculation(direction_rate, income_amount, outcome_amount, order_params.fetch(:request_direction))
      order = rate_calculation.build_order
      if rate_calculation.valid?
        order.save!
        redirect_to public_order_path(order), notice: 'Принята заявка на обмен. Ждём от Вас оплаты.'
      else
        render :new, locals: { order: order, rate_calculation: rate_calculation }
      end
    end

    def show
      render locals: { order: Order.find(params[:id]) }
    end

    private

    def build_rate_calculation direction_rate, income_amount, outcome_amount, request_direction
      calculator = RateCalculator.new(direction_rate)
      request_direction.to_s == 'from_income' ? calculator.build_from_income(income_amount) : calculator.build_from_outcome(outcome_amount)
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
