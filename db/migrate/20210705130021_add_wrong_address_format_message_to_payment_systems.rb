# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddWrongAddressFormatMessageToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :wrong_address_format_message, :string, null: false, default: 'Неверный формат'
  end
end
