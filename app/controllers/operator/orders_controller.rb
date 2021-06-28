# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class OrdersController < ApplicationController

    helper_method :current_tab

    before_action only: [:index] do
      redirect_to operator_orders_path(q: { tab_scope: :to_process }) unless params.key? :q
    end

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

    def paid
      order.action_operator = current_admin_user
      order.paid!
      redirect_to operator_order_path(order), notice: 'Деньги отправлены'
    end

    private

    def current_tab
      q_params['tab_scope']
    end

    def order
      @order ||= Order.find params[:id]
    end
  end
end
