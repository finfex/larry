# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddUserIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :user, null: true, foreign_key: true, type: :uuid
  end
end
