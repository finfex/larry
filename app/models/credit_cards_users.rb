# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreditCardUser < ApplicationRecord
  belongs_to :credit_card
  belongs_to :user
end
