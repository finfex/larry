# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class AddAccountsToWallets < ActiveRecord::Migration[6.1]
  def change
    remove_column :wallets, :currency_code
    remove_column :wallets, :amount_cents
    remove_column :wallets, :locked_cents
    remove_column :wallets, :total_cents

    add_reference :wallets, :available_account, foreign_key: { to_table: :openbill_accounts }, type: :uuid, null: false
    add_reference :wallets, :locked_account, foreign_key: { to_table: :openbill_accounts }, type: :uuid, null: false
  end
end
