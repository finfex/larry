class ChangeTypeOfEnumsInOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :state
    remove_column :orders, :request_direction

    add_column :orders, :state, :integer, null: false, default: 0
    add_column :orders, :request_direction, :integer, null: false, default: 0
  end
end
