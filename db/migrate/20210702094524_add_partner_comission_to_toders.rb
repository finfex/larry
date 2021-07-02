class AddPartnerComissionToToders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :referrer_accrual_method, :decimal
    add_column :orders, :referrer_profit_percentage, :decimal
    add_column :orders, :referrer_income_percentage, :decimal
    add_column :orders, :referrer_reward_cents, :decimal
    add_column :orders, :referrer_reward_currency, :string
  end
end
