# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module DirectionRateConcern
  extend ActiveSupport::Concern

  included do
    delegate :minimal_income_amount, :maximal_income_amount, to: :amounts_range_calculator
  end

  private

  def amounts_range_calculator
    @amounts_range_calculator ||= AmountsRangeCalculator.new(direction_rate: self)
  end
end
