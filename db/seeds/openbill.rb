# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

puts 'Seed openbill categories and accounts'

Settings.openbill.categories.each_pair do |name, id|
  OpenbillCategory.create_with(name: name).find_or_create_by!(id: id)
end

# TODO: Make specific policies
OpenbillPolicy.find_or_create_by(name: 'Allow all')

storno_category = OpenbillCategory.find_by(name: 'storno')


puts 'Create wallets for payment systems'
Gera::PaymentSystem.find_each do |ps|
  wallet = ps.wallets.create_for_payment_system! ps
  OpenbillCategory.storno.accounts.create! details: "Storno account for #{ps}", reference: ps
end

