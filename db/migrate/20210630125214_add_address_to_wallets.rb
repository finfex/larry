class AddAddressToWallets < ActiveRecord::Migration[6.1]
  def change
    add_column :wallets, :address, :string
    add_column :wallets, :income_enabled, :boolean, null: false, default: true
    add_column :wallets, :outcome_enabled, :boolean, null: false, default: true

    Wallet.find_each do |w|
      w.update_columns address: w.id
    end

    change_column_null :wallets, :address, false
    add_index :wallets, :address, unique: true
  end
end
