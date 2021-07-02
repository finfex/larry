# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Amount booked for specific order

class BookedAmount < ApplicationRecord
  belongs_to :payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :order

  monetize :amount_cents, as: :amount, allow_nil: false

  before_validation on: :create do
    self.amount = order.outcome_amount
    self.payment_system = order.outcome_payment_system
  end
end
