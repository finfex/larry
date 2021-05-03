# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    payment_system { nil }
    amount { '' }
    details { 'MyText' }
  end
end
