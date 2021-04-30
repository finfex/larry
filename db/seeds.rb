# frozen_string_literal: true

require 'factory_bot'

puts FactoryBot.definition_file_paths
puts 'Seed database'

FactoryBot.create :rate_source_exmo, title: 'exmo'
FactoryBot.create :rate_source_cbr, title: 'Russian Central Bank'
FactoryBot.create :rate_source_cbr_avg, title: 'Russian Central Bank (avg)'
FactoryBot.create :rate_source_manual, title: 'Manual'
FactoryBot.create :rate_source_bitfinex, title: 'bitfinex'

Money::Currency.all.each { |cur| Gera::PaymentSystem.create! name: cur.name, currency: cur }

Gera::CBRRatesWorker.new.perform
Gera::EXMORatesWorker.new.perform
Gera::DirectionsRatesWorker.new.perform
Gera::BitfinexRatesWorker.new.perform
