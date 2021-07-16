# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class UserToCreditCard < ApplicationRecord
  belongs_to :user
  belongs_to :credit_card
end
