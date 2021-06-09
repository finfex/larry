class AddBestchangeKeyToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :bestchange_key, :string

    Gera::PaymentSystem.find_each do |ps|
      ps.update! bestchange_key: ps.id
    end

    change_column_null :gera_payment_systems, :bestchange_key, false

    add_index :gera_payment_systems, :bestchange_key, unique: true
  end
end
