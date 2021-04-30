Gera.configure do |config|
  config.cross_pairs = { kzt: :rub, eur: :rub }
end

## Добавляем в модели Gera авторизацию и прочее
##
## Раньше это делали через Rails.application.config.after_initialize do
##
## но в development происходит перезагрузку классов и поэтому их нужно миксировать снова
##
#Rails.application.config.to_prepare do
  #module Gera
    #ApplicationController.before_action :require_login
    #[
      #BitfinexRatesWorker, CBRAvgRatesWorker, EXMORatesWorker, BinanceRatesWorker,
      #CreateHistoryIntervalsWorker, CurrencyRatesWorker, DirectionsRatesWorker, DumpValutaWorker,
      #PurgeCurrencyRatesWorker, PurgeDirectionRatesWorker
    #].each do |worker_class|
      #worker_class.send :prepend, UniqueWorker
    #end

    #class DirectionsRatesWorker
      #set_callback :perform, :after, :dump_rates

      #private

      #def dump_rates
        #GenerateCompositeStatusWorker.perform_async
        #DumpValutaWorker.perform_async
      #end
    #end

    #PaymentSystem.extend Enumerize
    #PaymentSystem.include PaymentSystemAccountFormats
    #PaymentSystem.include PaymentSystemCommands
    #PaymentSystem.include PaymentSystemServices
    #PaymentSystem.include PaymentSystemConcern
    #PaymentSystem.include PaymentSystemIndexDefaultConcern

    #DirectionRate.include DirectionRateConcern

    #Direction.include DirectionConcern

    #ExchangeRate.include ExchangeRateConcern
    #ExchangeRate.has_many :order_reservations, foreign_key: :emoney_id2

    #[
      #CurrencyRate, CurrencyRateMode, ExchangeRate, PaymentSystem
    #].each { |model| model.include Authority::Abilities }
  #end
#end

## Другой вариант:
##
## Использовать
##
## > ActiveSupport.on_load('gera.payment_system') { include MyActiveRecordHelper }
##
## и где-то при загрузке Gera вызывать этот hook:
##
## > ActiveSupport.run_load_hooks(:active_record, ActiveRecord::Base)
##
## Хороший пример: https://simonecarletti.com/blog/2011/04/understanding-ruby-and-rails-lazy-load-hooks/
##
