# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module RateCalculationSerialization
  def rate_calculation
    @rate_calculation ||= RateCalculation.load rate_calculation_dump
  end

  def rate_calculation=(value)
    self.rate_calculation_dump = value.dump
    @rate_calculation = value
  end
end
