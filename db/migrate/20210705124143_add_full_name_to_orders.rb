class AddFullNameToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :full_name, :string
  end
end
