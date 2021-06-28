# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :order_action do
    order { nil }
    message { 'MyString' }
    operator { nil }
  end
end
