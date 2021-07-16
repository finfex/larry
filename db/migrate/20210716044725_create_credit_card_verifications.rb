# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateCreditCardVerifications < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_card_verifications, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :order, foreign_key: true, type: :uuid
      t.references :user, foreign_key: true, type: :uuid
      t.string :session_id
      t.string :number, null: false
      t.string :full_name, null: false
      t.string :exp_year, null: false
      t.string :exp_month, null: false
      t.string :state, null: false
      t.string :image, null: false

      t.timestamps
    end
  end
end
