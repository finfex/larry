# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class HomeController < ApplicationController
    helper Gera::ApplicationHelper

    helper_method :income_payment_system, :outcome_payment_system, :income_payment_systems, :outcome_payment_systems, :income_amount, :direction, :direction_rate

    def index
      render locals: { order: build_order }
    end

    private

    def direction
      direction = Gera::Direction.new(ps_from: income_payment_system, ps_to: outcome_payment_system).freeze
    end

    def build_order
      if direction_rate.present?
        Order.new(
          income_amount: income_amount,
          income_payment_system: income_payment_system,
          outcome_payment_system: outcome_payment_system,
          outcome_amount: direction_rate.exchange(income_amount),
          direction_rate: direction_rate,
          rate_calculation: RateCalculation.create_from_income!(direction_rate: direction_rate, income_amount: income_amount)
        )
      else
        Order.new(
          income_amount: income_amount,
          income_payment_system: income_payment_system,
          outcome_payment_system: outcome_payment_system,
          outcome_amount: outcome_payment_system.currency.zero_money
        )
      end
    end

    def direction_rate
      @direction_rate ||= direction.direction_rate
    end

    def income_amount
      @income_amount ||= [params[:income_amount].to_f.to_money(income_payment_system.currency), income_payment_system.minimal_income_amount].max
    end

    def income_payment_systems
      PaymentSystem.alive.available.enabled.where(income_enabled: true).ordered
    end

    def outcome_payment_systems
      PaymentSystem.alive.available.enabled.where(outcome_enabled: true).ordered
    end

    def income_payment_system
      ps = income_payment_systems.find_by(id: params[:cur_from]) if params[:cur_from]
      ps || income_payment_systems.first
    end

    def outcome_payment_system
      ps = outcome_payment_systems.find_by(id: params[:cur_to]) if params[:cur_to]
      ps || outcome_payment_systems.where.not(id: income_payment_system).first
      # Подбор платежной системы из доступных в exchange_rate и для которых есть direction_rate
      #
      # exchange_rate.outcome_payment_system
    end

    def exchange_rate
      Gera::ExchangeRate.available.where(payment_system_from_id: income_payment_system.id).take
    end
  end
end
