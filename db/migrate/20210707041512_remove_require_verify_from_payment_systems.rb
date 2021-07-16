# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RemoveRequireVerifyFromPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    remove_column :gera_payment_systems, :require_verify
  end
end
