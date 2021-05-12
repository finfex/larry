# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :wallet_activity do
    wallet { nil }
    amount { '' }
    opposit_account { nil }
    details { 'MyString' }
    author { nil }
  end
end
