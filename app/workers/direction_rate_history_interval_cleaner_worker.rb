# frozen_string_literal: true

# удаляет все интервальные курсы старшне 3 месяцев
class DirectionRateHistoryIntervalCleanerWorker
  include Sidekiq::Worker
  LIFETIME = 2.month

  def perform
    Gera::DirectionRateHistoryInterval
      .unscoped
      .where('interval_to < ?', Time.zone.now - LIFETIME)
      .delete_all
  end
end
