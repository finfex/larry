module Daemons
  class RatesFetcher < Base
    @sleep_time = 1.seconds
    def process
      logger.info('Fetch external rates')
      fetch_extrenal_rates
      logger.info('Run currency rates worker')
      Gera::CurrencyRatesWorker.new.perform
      logger.info('Run direction rates worker')
      Gera::DirectionsRatesWorker.new.perform
    rescue => err
      report_exception err
      logger.error err
    end

    private

    def fetch_extrenal_rates
      Gera::RateSource.enabled.where.not(fetcher_klass: nil).find_each do |rate_source|
        if rate_source.fetcher_klass.present?
          logger.info "Fetch for #{rate_source.type}"
          rate_source.fetch!
        else
          logger.info "Skip #{rate_source.type} fetching (no fetcher_klass)"
        end
      end
    end
  end
end
