class AddPercentagesToPartners < ActiveRecord::Migration[6.1]
  def change
    add_column :partners, :accrual_method, :integer, null: false, default: 0
    add_column :partners, :profit_percentage, :decimal, default: 10, null: false
    add_column :partners, :income_percentage, :decimal, default: 0.1, null: false
  end
end
