# frozen_string_literal: true

class WalletDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[payment_system currency details available_amount locked_amount total_amount]
  end

  %i[available_amount locked_amount total_amount].each do |method|
    define_method method do
      h.format_money object.send(method)
    end
  end
end
