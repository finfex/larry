# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddOperatorToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :operator, null: true, foreign_key: { to_table: :admin_users }, type: :uuid
  end
end
