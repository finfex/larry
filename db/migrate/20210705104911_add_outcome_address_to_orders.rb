class AddOutcomeAddressToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :user_income_address, :string
  end
end
