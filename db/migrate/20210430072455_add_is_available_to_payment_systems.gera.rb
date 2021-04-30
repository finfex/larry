# frozen_string_literal: true

# This migration comes from gera (originally 20190314114844)

class AddIsAvailableToPaymentSystems < ActiveRecord::Migration[5.2]
  def change
    add_column :gera_payment_systems, :is_available, :boolean, null: false, default: true
  end
end
