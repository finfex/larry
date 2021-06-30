# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class WalletDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[payment_system currency address income_enable outcome_enable details available_amount locked_amount total_amount]
  end

  %i[available_amount locked_amount total_amount].each do |method|
    define_method method do
      h.format_money object.send(method)
    end
  end

  def payment_system
    h.link_to h.operator_payment_system_path(object.payment_system) do
      h.present_payment_system object.payment_system
    end
  end
end
