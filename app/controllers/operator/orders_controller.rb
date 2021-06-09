# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class OrdersController < ApplicationController
    def index
      render locals: { orders: Order.order('created_at desc') }
    end
  end
end
