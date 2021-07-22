# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Verified credit card
#
class CreditCard < ApplicationRecord
  include ClearCreditCardNumber

  belongs_to :verification, class_name: 'CreditCardVerification'
  has_and_belongs_to_many :users

  validates :number, credit_card_number: true
end
