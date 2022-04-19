# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class OrdersController < ApplicationController
    authorize_actions_for Order
    helper_method :current_state

    before_action only: [:index] do
      redirect_to operator_orders_path(q: { by_state: :user_confirmed }) unless params.key? :q
    end

    def change_operator
      order.change_operator! current_admin_user
      redirect_back fallback_location: operator_order_path(order), notice: 'Оператор установлен'
    end

    def cancel
      order.action_cancel! current_admin_user
      redirect_back fallback_location: operator_orders_path, notice: 'Заявка отменена'
    end

    def show
      render locals: { order: order }
    end

    def accept
      order.action_accept! current_admin_user
      redirect_to operator_order_path(order), notice: 'Заявка принята к обработке'
    end

    def done
      order.action_done! current_admin_user
      redirect_to operator_order_path(order), notice: 'Деньги отправлены'
    end

    private

    def current_state
      q_params['by_state']
    end

    def order
      @order ||= Order.find params[:id]
    end
  end
end
