# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class BookedAmountDecorator < ApplicationDecorator
  delegate_all

  def data_attribute(*args); end

  def order
    h.link_to object.order.uid, h.operator_order_path(object.order)
  end

  def amount
    h.format_money object.amount
  end
end
