class RemoveLockedAccountFromWallets < ActiveRecord::Migration[6.1]
  def change
    remove_column :wallets, :locked_account_id
    rename_column :wallets, :available_account_id, :account_id
  end
end
