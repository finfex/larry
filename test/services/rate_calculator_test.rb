# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class RateCalculatorTest < ActiveSupport::TestCase
  setup do
    @direction_rate = FactoryBot.create :gera_direction_rate
  end

  def test_build_from_income
    income_amount = Money.new(123, @direction_rate.income_currency)
    rate_calculation = RateCalculator
                       .new(@direction_rate)
                       .build_from_income(income_amount)

    assert_equal rate_calculation.request_direction, :from_income
    assert_equal rate_calculation.outcome_amount, Money.new(6642, @direction_rate.outcome_currency)
  end
  # let(:rate) { 27.89 }
  # let(:income_amount) { 40 }

  # let!(:currency_rate) { create :currency_rate, cur_from: USD, cur_to: NEO, rate_value: 1.0 / rate }
  # let(:income_payment_system) { create :payment_system, currency: currency_rate.currency_from }
  # let(:outcome_payment_system) { create :payment_system, currency: currency_rate.currency_to }
  # let(:exchange_rate) { create :exchange_rate, payment_system_from: income_payment_system, payment_system_to: outcome_payment_system, value: 10 }
  # let(:direction_rate) { create :direction_rate, exchange_rate: exchange_rate, currency_rate: currency_rate }
  # let(:income_money) { Money.from_amount income_amount, direction_rate.income_currency }

  # subject { RateCalculation.create_from_income! direction_rate: direction_rate, income_money: income_money }

  # it { expect(subject).to be_persisted }
  # it { expect(subject.outcome_amount).to eq Money.from_amount(1, NEO) }
  # it { expect(subject.suggested_income_amount).to eq Money.from_amount(30.99, USD) }
end
