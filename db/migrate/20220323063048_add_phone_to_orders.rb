class AddPhoneToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :user_phone, :string
    add_column :orders, :user_telegram, :string
  end
end
