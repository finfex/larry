# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RemoveIncomeConfirmationFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :income_confirm_operator_id
    remove_column :orders, :income_confirmed_at

    add_column :order_actions, :key, :string, null: false
    rename_column :order_actions, :message, :custom_message
    change_column_null :order_actions, :custom_message, true
  end
end
