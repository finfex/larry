# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class CreateWallets < ActiveRecord::Migration[6.1]
  def up
    create_table :wallets, id: :uuid do |t|
      t.references :payment_system, null: false, foreign_key: { to_table: :gera_payment_systems }, type: :uuid
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
