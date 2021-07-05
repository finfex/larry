# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

module Public
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @direction_rate = FactoryBot.create :gera_direction_rate
      @income_payment_system = @direction_rate.income_payment_system
      @outcome_payment_system = @direction_rate.outcome_payment_system
    end

    def test_new_order_page
      get public_root_url
      assert_response :success
    end

    def test_success_create_order
      order = {
        income_payment_system_id: @income_payment_system.id,
        outcome_payment_system_id: @outcome_payment_system.id,
        income_amount: 100,
        outcome_amount: 200,
        request_direction: :income,
        direction_rate_id: @direction_rate.id
      }
      post public_orders_url, params: { order: order }
      assert_response :success
    end
  end
end
