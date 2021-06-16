# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RemoveRateCalculations < ActiveRecord::Migration[6.1]
  def change
    drop_table :rate_calculations
    remove_column :orders, :rate_calculation_id
  end
end
