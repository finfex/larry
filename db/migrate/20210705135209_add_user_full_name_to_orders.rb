class AddUserFullNameToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :user_full_name, :string
  end
end
