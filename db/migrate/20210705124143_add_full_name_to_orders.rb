# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddFullNameToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :full_name, :string
  end
end
