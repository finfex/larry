# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :credit_card do
    number { 'MyString' }
    verification { nil }
  end
end
