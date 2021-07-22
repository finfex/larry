# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

module Public
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @direction_rate = FactoryBot.create :gera_direction_rate
      @income_payment_system = @direction_rate.income_payment_system
      @outcome_payment_system = @direction_rate.outcome_payment_system
      @admin_user = FactoryBot.create :admin_user
      @outcome_wallet = FactoryBot.create :wallet, payment_system: @outcome_payment_system
      @income_wallet = FactoryBot.create :wallet, payment_system: @income_payment_system
    end

    def test_new_order_page
      get public_root_url
      assert_response :success
    end

    # No amount reserves
    # def test_order_verification_failed
    # @income_payment_system.update require_verify_income_card: false
    # order = {
    # income_payment_system_id: @income_payment_system.id,
    # outcome_payment_system_id: @outcome_payment_system.id,
    # income_amount: 100,
    # request_direction: :from_income,
    # direction_rate_id: @direction_rate.id
    # }
    # post public_orders_url, params: { order: order }
    # assert_response :success
    # assert_equal Order.count, 0
    # end

    def test_success_order
      WalletCorrectionCommand.call(
        wallet: @outcome_wallet,
        admin_user: @admin_user,
        amount: 100_000.to_money(@outcome_payment_system.currency),
        details: 'aha'
      )
      # @income_payment_system.update require_verify_income_card: true

      order = {
        income_payment_system_id: @income_payment_system.id,
        outcome_payment_system_id: @outcome_payment_system.id,
        income_amount: 100,
        request_direction: :from_income,
        direction_rate_id: @direction_rate.id
      }
      post public_orders_url, params: { order: order }
      assert_response :redirect
      created_order = Order.last
      assert created_order.wait?
    end

    def test_send_order_to_verify_card
      WalletCorrectionCommand.call(
        wallet: @outcome_wallet,
        admin_user: @admin_user,
        amount: 100_000.to_money(@outcome_payment_system.currency),
        details: 'aha'
      )
      @income_payment_system.update require_verify_income_card: true

      order = {
        income_payment_system_id: @income_payment_system.id,
        outcome_payment_system_id: @outcome_payment_system.id,
        income_amount: 100,
        request_direction: :from_income,
        direction_rate_id: @direction_rate.id
      }
      post public_orders_url, params: { order: order }
      assert_response :redirect
      created_order = Order.last
      assert created_order.verify?
    end
  end
end
