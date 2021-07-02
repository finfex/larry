# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :booked_amount do
    payment_system { nil }
    amount_cents { '9.99' }
    amount_currency { 'MyString' }
    order { nil }
  end
end
