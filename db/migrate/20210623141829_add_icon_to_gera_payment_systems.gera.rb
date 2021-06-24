# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddIconToGeraPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    rename_column :gera_payment_systems, :icon_url, :icon
  end
end
