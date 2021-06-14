# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module DirectionRateSerialization
  extend ActiveSupport::Concern

  def self.save_all
    [Order, RateCalculation].each do |model|
      scope = model.where(direction_rate_dump: nil).where.not(direction_rate_id: nil)
      pb = ProgressBar.create total: scope.count, title: model.name
      scope.find_each do |rec|
        if rec.is_a? RateCalculation
          rec.update_column :direction_rate_dump, rec.direction_rate.dump
        else
          rec.update_columns direction_rate_dump: rec.direction_rate.dump, rub_currency_rate_dump: rec.send(:build_dump_rub_rates)
        end
        pb.increment
      end
    end
  end

  included do
    before_create if: :direction_rate do
      direction_rate.update_column :is_used, true unless direction_rate.is_used?
      self.direction_rate_dump ||= direction_rate.dump

      self.rate_value = direction_rate.rate_value
      self.base_rate_value = direction_rate.base_rate_value
      self.rate_percent = direction_rate.rate_percent
    end
  end

  def direction_rate_dumped
    return unless direction_rate_dump.present?

    @direction_rate_dumped ||= Gera::DirectionRate.new(direction_rate_dump).freeze
  end
end
