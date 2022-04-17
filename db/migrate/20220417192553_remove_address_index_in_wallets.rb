class RemoveAddressIndexInWallets < ActiveRecord::Migration[6.1]
  def change
    remove_index :wallets, :address
    add_index :wallets, [:payment_system_id, :address], unique: true
  end
end
