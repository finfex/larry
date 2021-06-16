# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddRequestDirectionToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :request_direction, :string, null: false
  end
end
