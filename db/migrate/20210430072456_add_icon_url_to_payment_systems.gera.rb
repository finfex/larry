# frozen_string_literal: true

# This migration comes from gera (originally 20190315113046)

class AddIconUrlToPaymentSystems < ActiveRecord::Migration[5.2]
  def change
    add_column :gera_payment_systems, :icon_url, :string
  end
end
