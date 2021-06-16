# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :openbill_category do
    name { generate :name }
  end
end
