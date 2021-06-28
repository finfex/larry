# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class OrdersController < ApplicationController

    def cancel
      order.action_operator = current_admin_user
      order.cancel!
      redirect_back fallback_location: operator_orders_path, notice: 'Заявка отменена'
    end

    def show
      render locals: { order: order }
    end

    def accept
      order.action_operator = current_admin_user
      order.operator = current_admin_user
      order.accept!
      redirect_to operator_order_path(order), notice: 'Заявка принята к обработке'
    end

    private

    def order
      @order ||= Order.find params[:id]
    end
  end
end
