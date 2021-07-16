# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :user_to_credit_card do
    user { nil }
    credit_card { nil }
  end
end
