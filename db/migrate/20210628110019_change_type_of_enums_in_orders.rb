# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ChangeTypeOfEnumsInOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :state
    remove_column :orders, :request_direction

    add_column :orders, :state, :integer, null: false, default: 0
    add_column :orders, :request_direction, :integer, null: false, default: 0
  end
end
