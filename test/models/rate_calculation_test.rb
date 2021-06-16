# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class RateCalculationTest < ActiveSupport::TestCase
  setup do
    @direction_rate = FactoryBot.create :gera_direction_rate
  end

  def test_new
    assert RateCalculation.new
  end

  def test_invalid
    refute RateCalculation.new.valid?
  end
end
