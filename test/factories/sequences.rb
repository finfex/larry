# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  sequence :name do |n|
    "name#{n}"
  end
  sequence :number do |n|
    n
  end
  sequence :phone do |n|
    "+7903389122#{n}"
  end
  sequence :email do |n|
    "email#{n}@onelec.ru"
  end

  sequence :wallet_address, &:to_s
end
