# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddBasedIncomeAmount < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :based_income_amount_cents, :decimal, null: true
    add_column :orders, :based_income_amount_currency, :string, null: true

    Order.where(referrer_reward_cents: nil).destroy_all
    Order.find_each do |order|
      order.update! based_income_amount: order.income_amount.exchange_to(Settings.rewards_currency)
    end

    change_column_null :orders, :based_income_amount_cents, false
    change_column_null :orders, :based_income_amount_currency, false
  end
end
