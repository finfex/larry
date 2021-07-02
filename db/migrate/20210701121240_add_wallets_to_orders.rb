class AddWalletsToOrders < ActiveRecord::Migration[6.1]
  def up
    Order.destroy_all
    add_reference :orders, :income_wallet, null: false, foreign_key: { to_table: :wallets }, type: :uuid
    add_reference :orders, :outcome_wallet, null: false, foreign_key: { to_table: :wallets }, type: :uuid

    add_column :orders, :income_address, :string, null: false
    add_column :orders, :income_confirmed_at, :timestamp
    add_reference :orders, :income_confirm_operator, foreign_key: { to_table: :admin_users }, type: :uuid
    add_column :orders, :user_confirmed_at, :timestamp

    add_column :wallets, :last_used_as_income_at, :timestamp
    add_column :wallets, :last_used_as_outcome_at, :timestamp
  end

  def down
    remove_column :orders, :income_wallet_id_id
    remove_column :orders, :outcome_wallet_id_id
    remove_column :orders, :income_address
    remove_column :orders, :income_confirm_operator_id_id
    remove_column :orders, :user_confirmed_at
  end
end
