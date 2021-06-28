# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateOrderActions < ActiveRecord::Migration[6.1]
  def change
    create_table :order_actions, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.string :message, null: false
      t.references :operator, null: true, foreign_key: { to_table: :admin_users }, type: :uuid

      t.timestamps
    end
  end
end
