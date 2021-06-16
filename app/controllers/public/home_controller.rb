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

    def final_reserves
      @final_reserves ||= ReservesByPaymentSystems.new.final_reserves
    end

    def rate_calculation
      @rate_calculation ||= RateCalculation.new(direction_rate: direction_rate).tap do |rc|
        request_direction == :from_income ? rc.build_from_income(income_amount) : rc.build_from_outcome(outcome_amount)
      end
    end

    def request_direction
      rd = params.fetch(:request_direction, :from_income).to_sym
      return rd if RateCalculation::DIRECTIONS.include?(rd)

      :from_income
    end

    def direction
      Gera::Direction.new(ps_from: income_payment_system, ps_to: outcome_payment_system).freeze
    end

    def outcome_amount
      direction_rate.nil? ? outcome_payment_system.currency.zero_money : direction_rate.exchange(income_amount)
    end

    def direction_rate
      @direction_rate ||= direction.direction_rate
    end

    def income_amount
      @income_amount ||= [
        params[:income_amount].to_f.to_money(income_payment_system.currency),
        income_payment_system.minimal_income_amount
      ].max
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
