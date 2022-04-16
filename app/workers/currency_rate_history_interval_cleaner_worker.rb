# frozen_string_literal: true

# удаляет все интервальные курсы валют старшне 3 месяцев
class CurrencyRateHistoryIntervalCleanerWorker
  include Sidekiq::Worker
  LIFETIME = 2.month

  def perform
    Gera::CurrencyRateHistoryInterval
      .where('interval_to < ?', Time.zone.now - LIFETIME)
      .delete_all
  end
end
