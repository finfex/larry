# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateWalletActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :wallet_activities, id: :uuid do |t|
      t.references :wallet, null: false, foreign_key: true, type: :uuid
      t.money :amount, null: false
      t.references :opposit_account, null: false, foreign_key: { to_table: :openbill_accounts }, type: :uuid
      t.string :details, null: false
      t.references :admin_user, null: false
      t.string :activity_type, null: false

      t.timestamps
    end
  end
end
