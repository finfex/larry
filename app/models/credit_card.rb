# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Verified credit card
#
class CreditCard < ApplicationRecord
  belongs_to :verification, class_name: 'CreditCardVerification'
  validates :number, credit_card_number: true
end
