# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddRequireFullNameToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :require_full_name_on_income, :boolean, null: false, default: false
    add_column :gera_payment_systems, :require_full_name_on_outcome, :boolean, null: false, default: false
  end
end
