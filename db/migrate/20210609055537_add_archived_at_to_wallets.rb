# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddArchivedAtToWallets < ActiveRecord::Migration[6.1]
  def change
    add_column :wallets, :archived_at, :timestamp
  end
end
