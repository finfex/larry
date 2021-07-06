# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddUserEmailToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :user_email, :string
    add_column :gera_payment_systems, :require_email_on_income, :boolean, default: false, null: false
    add_column :gera_payment_systems, :require_email_on_outcome, :boolean, default: false, null: false
  end
end
