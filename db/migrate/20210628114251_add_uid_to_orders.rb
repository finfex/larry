class AddUidToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :uid, :string

    Order.find_each do |o|
      o.send :assign_uid
      o.save!
    end

    change_column :orders, :uid, :string, null: false

    add_index :orders, :uid, unique: true
  end
end
