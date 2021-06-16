# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    payment_system factory: :gera_payment_system
    details { 'MyText' }
    available_account factory: :openbill_account
    locked_account factory: :openbill_account
  end
end
