class AddReservesDeltaAmountToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :reserves_delta_cents, :decimal, null: false, default: 0
  end
end
