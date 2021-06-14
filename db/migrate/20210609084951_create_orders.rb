# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.decimal :income_amount_cents, null: false
      t.string :income_amount_currency, null: false
      t.decimal :outcome_amount_cents, null: false
      t.string :outcome_amount_currency, null: false
      t.references :income_payment_system, null: false, foreign_key: { to_table: :gera_payment_systems }, type: :uuid
      t.references :outcome_payment_system, null: false, foreign_key: { to_table: :gera_payment_systems }, type: :uuid
      t.references :direction_rate, null: true, foreign_key: { to_table: :gera_direction_rates }, type: :uuid
      t.json :direction_rate_dump, null: false
      t.decimal 'rate_value', null: false
      t.decimal 'base_rate_value', null: false
      t.decimal 'rate_percent', null: false

      t.timestamps
    end
  end
end
