# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateCreditCards < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_cards, id: :uuid do |t|
      t.string :number, null: false
      t.references :verification, null: false, foreign_key: { to_table: :credit_card_verifications }, type: :uuid
      t.string :full_name, null: false
      t.string :exp_year, null: false
      t.string :exp_month, null: false
      t.timestamps
    end

    add_index :credit_cards, :number, unique: true
  end
end
