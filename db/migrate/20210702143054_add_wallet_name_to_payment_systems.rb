class AddWalletNameToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :wallet_name, :string, null: false, default: 'Wallet'
  end
end
