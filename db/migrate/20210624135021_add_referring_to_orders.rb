# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddReferringToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :ref_token, :string
    add_reference :orders, :referrer, null: true, foreign_key: { to_table: :partners }, type: :uuid
    add_column :orders, :state, :string, null: false, default: :draft
    add_index :orders, %i[referrer_id state created_at]
  end
end
