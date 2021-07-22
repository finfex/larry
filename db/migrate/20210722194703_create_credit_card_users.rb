# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateCreditCardUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_card_users, id: :uuid do |t|
      t.references :credit_card, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :credit_card_users, %i[credit_card_id user_id], unique: true
  end
end
