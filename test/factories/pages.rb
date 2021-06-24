# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :page do
    path { 'MyString' }
    title { 'MyString' }
    content { 'MyText' }
  end
end
