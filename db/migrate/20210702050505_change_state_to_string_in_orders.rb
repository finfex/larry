# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ChangeStateToStringInOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :state
    add_column :orders, :state, :string, default: :draft, null: false

    add_index :orders, :state
  end
end
