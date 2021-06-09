# frozen_string_literal: true

class PurgeRateCalculationsWorker
  KEEP_PERIOD = 1.week

  include Sidekiq::Worker
  prepend UniqueWorker

  sidekiq_options queue: :purgers, retry: false

  def perform
    RateCalculation.where('created_at < ?', KEEP_PERIOD.ago).batch_purge
  end
end
