# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddRateCalculationDumpToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :rate_calculation_dump, :jsonb, null: false
  end
end
