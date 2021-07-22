# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :credit_card_verification do
    number { '3700 0000 0000 002' }
    full_name { generate :name }
    image { Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/card.png'), 'image/png') }
  end
end
