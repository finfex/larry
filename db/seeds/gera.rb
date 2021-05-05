# frozen_string_literal: true

require 'factory_bot'

puts FactoryBot.definition_file_paths
puts 'Seed GERA database'

puts 'Create sources'
FactoryBot.create :rate_source_exmo, title: 'exmo'
FactoryBot.create :rate_source_cbr, title: 'Russian Central Bank'
FactoryBot.create :rate_source_cbr_avg, title: 'Russian Central Bank (avg)'
FactoryBot.create :rate_source_manual, title: 'Manual'
FactoryBot.create :rate_source_bitfinex, title: 'bitfinex'

puts 'Create payments systems for every currencies'
Money::Currency.all.each { |cur| Gera::PaymentSystem.create! name: cur.name, currency: cur, income_enabled: true, outcome_enabled: true }

puts 'Fetch rates'

puts 'Fetch ЦБРФ'
Gera::CBRRatesWorker.new.perform

puts 'Fetch EXMO'
Gera::EXMORatesWorker.new.perform

puts 'Build DirectionsRates'
Gera::DirectionsRatesWorker.new.perform

puts 'Build BitfinexRates'
Gera::BitfinexRatesWorker.new.perform

Gera::ExchangeRate.update_all is_enabled: true
