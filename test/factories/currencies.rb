# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :currency do
    iso_code { 'MyString' }
    available { false }
  end
end
