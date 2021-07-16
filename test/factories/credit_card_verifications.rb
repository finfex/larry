# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :credit_card_verification do
    credit_card_number { 'MyString' }
    user { nil }
    status { 'MyString' }
  end
end
