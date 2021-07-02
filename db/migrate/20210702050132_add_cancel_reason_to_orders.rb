# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddCancelReasonToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :cancel_reason, :string
    add_column :orders, :user_remote_ip, :string
    add_column :orders, :user_agent, :string
  end
end
