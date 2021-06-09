class AddSystemTypeToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :system_type, :string
  end
end
