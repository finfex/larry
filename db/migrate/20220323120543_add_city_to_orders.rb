class AddCityToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :city
  end
end
