# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateUserToCreditCards < ActiveRecord::Migration[6.1]
  def change
    create_table :user_to_credit_cards, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :credit_card, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :user_to_credit_cards, %i[user_id credit_card_id], unique: true
  end
end
