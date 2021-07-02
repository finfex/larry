# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateBookedAmounts < ActiveRecord::Migration[6.1]
  def change
    create_table :booked_amounts, id: :uuid do |t|
      t.references :payment_system, null: false, foreign_key: { to_table: :gera_payment_systems }, type: :uuid
      t.decimal :amount_cents, null: false
      t.string :amount_currency, null: false
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.timestamp :created_at, null: false
    end
  end
end
