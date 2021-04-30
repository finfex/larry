# frozen_string_literal: true

namespace :gera do
  desc 'Update rates'
  task update_rates: :environment do
    # TODO: Automaticaly find necessary sources
    [
      Gera::CBRRatesWorker,
      Gera::EXMORatesWorker,
      Gera::BitfinexRatesWorker,
      Gera::CurrencyRatesWorker,
      Gera::DirectionsRatesWorker
    ].each do |worker|
      puts worker
      worker.new.perform
    end
  end
end
