# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddCurrencyToWalletActivities < ActiveRecord::Migration[6.1]
  def change
    WalletActivity.delete_all
    add_column :wallet_activities, :amount_currency, :string, null: false
  end
end
