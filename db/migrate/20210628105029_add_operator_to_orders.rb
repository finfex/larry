class AddOperatorToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :operator, null: true, foreign_key: { to_table: :admin_users }, type: :uuid
  end
end
