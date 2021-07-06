# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddUserFullNameToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :user_full_name, :string
  end
end
