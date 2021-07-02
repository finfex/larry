# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    payment_system factory: :gera_payment_system
    details { 'MyText' }
    address { generate :wallet_address }
    account factory: :openbill_account
  end
end
