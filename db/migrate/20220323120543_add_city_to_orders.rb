class AddCityToOrders < ActiveRecord::Migration[6.1]
  def up
    add_reference :orders, :city, foreign_key: true, type: :uuid
  end

  def down
    remove_column :orders, :city_id
  end
end
