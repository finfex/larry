class SeedFetcherKlass < ActiveRecord::Migration[6.1]
  def change
    {
      'Gera::RateSourceEXMO': 'Gera::EXMORatesFetcher',
      'Gera::RateSourceCBR': 'Gera::CBRRatesFetcher',
      'Gera::RateSourceCBRAvg': 'Gera::CBRAvgRatesFetcher',
      'Gera::RateSourceBitfinex': 'Gera::BitfinexRatesFetcher'
    }.each_pair do |type, fetcher_klass|
      Gera::RateSource.where(type: type).update_all fetcher_klass: fetcher_klass
    end
  end
end
