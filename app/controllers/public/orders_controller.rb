# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class OrdersController < ApplicationController
    def create
      order = OrdersCreator.new.call order_params
      redirect_to public_order_path(order), notice: 'Принята заявка на обмен. Ждём от Вас оплаты.'
    end

    def show
      render locals: { order: Order.find(params[:id]) }
    end

    private

    def order_params
      params
        .require(:order)
        .permit(:request_direction,
                :income_payment_system_id,
                :outcome_payment_system_id,
                :income_amount,
                :outcome_amount,
                :direction_rate_id,
                :rate_calculation_id)
    end
  end
end
