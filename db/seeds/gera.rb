# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'factory_bot'

puts FactoryBot.definition_file_paths
puts 'Seed GERA database'

puts 'Create sources'
FactoryBot.create :rate_source_exmo, title: 'exmo', fetcher_klass: 'Gera::EXMORatesFetcher'
FactoryBot.create :rate_source_cbr, title: 'Russian Central Bank', fetcher_klass: 'Gera::CBRRatesFetcher'
FactoryBot.create :rate_source_cbr_avg, title: 'Russian Central Bank (avg)', fetcher_klass: 'Gera::CBRAvgRatesFetcher', is_enabled: false
FactoryBot.create :rate_source_bitfinex, title: 'bitfinex', fetcher_klass: 'Gera::BitfinexRatesFetcher'
FactoryBot.create :rate_source_manual, title: 'Manual'

puts 'Create payments systems for every currencies'
Money::Currency.all.each do |cur|
  Gera::PaymentSystem.create_with(
    name: cur.name,
    income_enabled: true,
    outcome_enabled: true,
    minimal_income_amount: (cur.is_crypto? ? 0.01 : 10).to_money(cur),
    maximal_income_amount: (cur.is_crypto? ? 1 : 1000).to_money(cur),
    bestchange_key: cur.name
  ).find_or_create_by!(currency_iso_code: cur)
end

puts 'Fetch rates'

Daemons::ExternalRatesFetcher.new.process

Gera::ExchangeRate.update_all is_enabled: true
