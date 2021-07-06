# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class OrdersController < ApplicationController
    helper Gera::ApplicationHelper
    helper Gera::DirectionRateHelper

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Layout/LineLength
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/CyclomaticComplexity
    def new
      income_payment_system = income_payment_systems.find_by(id: params[:income_payment_system_id]) if params[:income_payment_system_id]
      income_payment_system ||= income_payment_systems.find_by(bestchange_key: params[:cur_from]) if params[:cur_from]
      income_payment_system ||= income_payment_systems.first

      outcome_payment_system = outcome_payment_systems.find_by(id: params[:outcome_payment_system_id]) if params[:outcome_payment_system_id]
      outcome_payment_system ||= outcome_payment_systems.find_by(bestchange_key: params[:cur_to]) if params[:cur_to]
      outcome_payment_system ||= outcome_payment_systems.where.not(id: income_payment_system).first
      # Подбор платежной системы из доступных в exchange_rate и для которых есть direction_rate
      #
      # exchange_rate.outcome_payment_system
      # Gera::ExchangeRate.available.where(payment_system_from_id: income_payment_system.id).take
      #
      direction = Gera::Direction.new(ps_from: income_payment_system, ps_to: outcome_payment_system).freeze
      direction_rate = direction.direction_rate

      calculator = RateCalculator.new(direction_rate)
      rate_calculation = if params.fetch('request_direction',
                                         'from_income') == 'from_income'
                           calculator.build_from_income(
                             params[:income_amount].present? ? params[:income_amount].to_d.to_money(income_payment_system.currency) : income_payment_system.minimal_income_amount
                           )
                         else
                           calculator.build_from_outcome(
                             direction_rate.nil? ? outcome_payment_system.currency.zero_money : direction_rate.exchange(income_amount)
                           )
                         end
      rate_calculation.validate
      order = rate_calculation.build_order
      order.income_payment_system = income_payment_system
      order.outcome_payment_system = outcome_payment_system
      render locals: { order: order, rate_calculation: rate_calculation }
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Layout/LineLength
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def create
      direction_rate = Gera::DirectionRate.find order_params.fetch(:direction_rate_id)
      calculator = RateCalculator.new(direction_rate)

      rate_calculation = if order_params.fetch(:request_direction).to_s == 'from_income'
                           calculator.build_from_income(order_params.fetch(:income_amount).to_money(direction_rate.income_currency))
                         else
                           calculator.build_from_outcome(order_params.fetch(:outcome_amount).to_money(direction_rate.outcome_currency))
                         end

      # TODO: Проверять не устарел ли курс
      order = rate_calculation.build_order(order_params)
      if rate_calculation.valid?
        create_order order
        redirect_to public_order_path(order), notice: 'Принята заявка на обмен. Ждём от Вас оплаты.'
      else
        render :new, locals: { order: order, rate_calculation: rate_calculation }
      end
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? Order

      render :new, locals: { order: order, rate_calculation: rate_calculation }
    end
    # rubocop:enable Metrics/MethodLength

    def show
      render locals: { order: Order.find(params[:id]) }
    end

    def confirm
      order = Order.find(params[:id])
      order.action_user_confirm! if order.user_confirmed_at.nil?
      redirect_to public_order_path(order), notice: 'Принято уведомлени об отправке средств'
    end

    private

    def create_order(order)
      # TODO: Move to OrderCreator. Lock balances, save referrals
      Order.transaction do
        order.user_remote_ip = request.remote_ip
        order.user_agent = request.user_agent
        order.user = current_user
        order.ref_token = current_ref_token
        select_wallets order
        add_referrer order
        order.save!
        order.actions.create! key: :created
        order.create_booked_amount!
      end
    end

    def select_wallets(order)
      wallet_selector = WalletSelector.new(order)
      order.income_wallet = wallet_selector.select_income_wallet
      order.outcome_wallet = wallet_selector.select_outcome_wallet
    end

    def add_referrer(order)
      if current_referrer.present?
        order.referrer = current_referrer
        order.referrer_accrual_method = current_referrer.accrual_method
        order.referrer_profit_percentage = current_referrer.profit_percentage
        order.referrer_income_percentage = current_referrer.income_percentage
        order.referrer_reward = RewardCalculator
                                .call(accrual_method: current_referrer.accrual_method,
                                      profit_percentage: current_referrer.profit_percentage,
                                      income_percentage: current_referrer.income_percentage,
                                      income_amount: order.income_amount,
                                      direction_rate: order.direction_rate)
      else
        order.referrer_reward = order.income_amount.currency.zero_money
      end
    end

    def order_params
      params
        .require(:order)
        .permit(:request_direction,
                :user_income_address,
                :user_full_name,
                :income_amount,
                :outcome_amount,
                :direction_rate_id)
    end
  end
end
