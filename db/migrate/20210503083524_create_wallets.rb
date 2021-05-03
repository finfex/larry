# frozen_string_literal: true

class CreateWallets < ActiveRecord::Migration[6.1]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS pgcrypto;'
    create_table :wallets, id: :uuid do |t|
      t.references :payment_system, null: false, foreign_key: { to_table: :gera_payment_systems }, type: :integer
      t.string :currency_code, null: false
      t.decimal :amount_cents, null: false, default: 0
      t.decimal :locked_cents, null: false, default: 0
      t.decimal :total_cents, null: false, default: 0
      t.text :details

      t.timestamps
    end
  end

  def down
    drop_table :wallets
  end
end
