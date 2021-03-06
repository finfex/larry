# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddReservesAggregatorIdToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_reference :gera_payment_systems, :reserves_aggregator, foreign_key: { to_table: :gera_payment_systems }, type: :uuid
  end
end
