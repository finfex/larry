class AddArchivedAtToWallets < ActiveRecord::Migration[6.1]
  def change
    add_column :wallets, :archived_at, :timestamp
  end
end
