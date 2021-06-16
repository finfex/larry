# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :openbill_account do
    category factory: :openbill_category
  end
end
