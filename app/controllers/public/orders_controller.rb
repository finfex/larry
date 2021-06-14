# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class OrdersController < ApplicationController
    def create
      order = create_order order_params
      redirect_to public_order_path(order), notice: 'Принята заявка на обмен. Ждём от Вас оплаты.'
    end

    def show
      render locals: { order: Order.find(params[:id]) }
    end

    private

    def create_order(order_params)
      order = Order.new order_params
      order.save!
      order
    end

    def order_params
      params
        .require(:order)
        .permit(:income_payment_system_id, :outcome_payment_system_id, :income_amount, :outcome_amount, :direction_rate_id, :rate_calculation_id)
    end
  end
end
