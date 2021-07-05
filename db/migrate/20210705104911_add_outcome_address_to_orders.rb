# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddOutcomeAddressToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :user_income_address, :string
  end
end
