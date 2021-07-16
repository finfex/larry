# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

puts 'Seed openbill categories and accounts'

Settings.openbill.categories.each_pair do |name, id|
  OpenbillCategory.create_with(name: name).find_or_create_by!(id: id)
end

# TODO: Make specific policies
OpenbillPolicy.find_or_create_by(name: 'Allow all')

puts 'Create wallets for payment systems'
Gera::PaymentSystem.find_each do |ps|
  OpenbillCategory.storno.accounts.create! details: "Storno account for #{ps}", reference: ps, amount: ps.currency.zero_money
end
