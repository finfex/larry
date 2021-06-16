# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Public order creator:
#
# 1. Validate data
# 2. Create order
# 3. Notify managers
#
class OrderCreator
  def call(income_payment_system_id:, outcome_payment_system_id:, income_amount:, outcome_amount:, direction_rate_id:, rate_calculation_id:); end

  private

  def create_order(order_params)
    order = Order.new order_params
    order.save!
    order
  end
end
