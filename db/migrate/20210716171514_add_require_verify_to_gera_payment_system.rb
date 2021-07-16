# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddRequireVerifyToGeraPaymentSystem < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :require_verify, :boolean, null: false, default: false
  end
end
