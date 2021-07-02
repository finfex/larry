# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class WalletDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[payment_system currency address income_enabled outcome_enabled details available_amount]
  end

  def available_amount
    h.format_money object.available_amount
  end

  def payment_system
    h.link_to h.operator_payment_system_path(object.payment_system) do
      h.present_payment_system object.payment_system
    end
  end
end
