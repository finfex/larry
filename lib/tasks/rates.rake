namespace :gera do
  desc 'Update rates'
  task :update_rates => :environment do
    Gera::CurrencyRatesWorker.new.perform
    Gera::DirectionsRatesWorker.new.perform
  end
end
