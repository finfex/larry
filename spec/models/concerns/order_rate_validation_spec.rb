# frozen_string_literal: true

require 'rails_helper'

describe OrderRateValidation do
  let(:income_currency)         { USD }
  let!(:income_payment_system)  { create :payment_system_with_wallets, currency: income_currency, account_format: 'payeer' }
  let(:outcome_currency)        { RUB }
  let!(:outcome_payment_system) { create :payment_system, currency: outcome_currency, account_format: :by_currency }
  let!(:outcome_wallet)         { create :wallet, active: true, payment_system: outcome_payment_system, balance: wallet_balance }
  let(:exchange_rate)           do
    Gera::ExchangeRate.find_by(payment_system_from: income_payment_system, payment_system_to: outcome_payment_system) ||
      create(:exchange_rate, outcome_payment_system: outcome_payment_system, income_payment_system: income_payment_system, is_enabled: true)
  end
  let(:direction_rate)          { create :direction_rate, exchange_rate: exchange_rate }
  let(:rate_calculation)        { RateCalculation.create_from_income! direction_rate: direction_rate, income_money: Money.from_amount(income_amount, income_currency) }
  let(:wallet_balance)          { 100 }
  let(:outcome_account)         { '' }
  let(:income_account)          { 'P39219692' }
  let(:currency_rate)           { build :currency_rate, cur_from: 'BTC', cur_to: 'RUB', rate_value: 467_793.83367711486 }
  let(:outcome_amount) { rate_calculation.outcome_amount.to_f }

  before do
    allow_any_instance_of(Gera::CurrencyRatesRepository).to receive(:find_currency_rate_by_pair).and_return currency_rate
    allow_any_instance_of(Gera::ExchangeRate).to receive(:is_enabled?).and_return(true)
    allow_any_instance_of(Gera::PaymentSystem).to receive(:has_enough_reserves?).and_return true
  end

  subject { build :preliminary_order, rate_calculation: rate_calculation, income_account: income_account, direction_rate: direction_rate, income_amount: income_amount, outcome_amount: outcome_amount, outcome_account: outcome_account }

  let(:direction_rate) { create :direction_rate, exchange_rate: exchange_rate, finite_rate: finite_rate, base_rate_value: 1, rate_percent: 1 }

  describe 'неверный курс USD/RUB' do
    let(:finite_rate) { 88.09 }
    let(:income_amount) { 3.0 }
    let(:wallet_balance) { outcome_amount * 2 }

    it { expect(subject).to be_valid }

    context 'близко то тоже перебор' do
      let(:outcome_amount) { 266.28 }
      it do
        expect(subject).to_not be_valid
        expect(subject.errors).to include(:outcome_amount)
      end
    end
  end

  describe 'неверный курс RUB/BTC' do
    # Специально пробелы в конце чтобы проверить как сработает strip/squish
    let(:outcome_account) { "18Vvptk3wUMk64kacnFSBWMv5GtWHGPNLF \n  " }
    let(:finite_rate) { 1.5048067439900574e-06 }
    let(:income_amount) { 14_000.0 }
    let(:income_currency) { RUB }
    let(:outcome_currency) { BTC }

    it { expect(subject).to be_valid }

    context 'ну это уже перебор' do
      let(:outcome_amount) { 0.021069 }
      it do
        expect(subject).to_not be_valid
        expect(subject.errors).to include(:outcome_amount)
      end
    end
  end

  describe 'RUB/BTC' do
    let(:outcome_account)  { '18Vvptk3wUMk64kacnFSBWMv5GtWHGPNLF' }
    let(:finite_rate)      { 2.1458890025349146e-06 }
    let(:income_currency)  { RUB }
    let(:outcome_currency) { BTC }
    let(:income_amount)    { 3462.43 }

    it { expect(subject).to be_valid }

    context 'слегка не точный' do
      let(:outcome_amount) { 0.00743 }
      it do
        expect(subject).to_not be_valid
        expect(subject.errors).to include(:outcome_amount)
      end
    end
  end

  describe 'не совсем верный курс RUB/ETH' do
    let(:outcome_account)        { '12f7c4c8977a5b9addb52b83e23c9d0f3b89be15' }
    let(:finite_rate)            { 2.6008197273087086e-05 }
    let(:income_amount)          { 5000.0 }
    let(:outcome_amount)         { 0.130041 }
    let(:income_currency)        { RUB }
    let(:outcome_currency)       { ETH }
    let!(:currenty_rate_eth_rub) { create :currency_rate, snapshot: direction_rate.currency_rate.snapshot, cur_from: :RUB, cur_to: :ETH }

    it do
      expect(subject).to_not be_valid
      expect(subject.errors).to include(:outcome_amount)
    end
  end

  describe 'устаревший курс' do
    let(:outcome_account)  { '12f7c4c8977a5b9addb52b83e23c9d0f3b89be15' }
    let(:finite_rate)      { 2.6008197273087086e-05 }
    let(:income_amount)    { 5000.0 }
    let(:income_currency)  { RUB }
    let(:outcome_currency) { ETH }

    it 'курс уже устарел' do
      subject
      Timecop.freeze(Date.today + 10) do
        expect(subject).to_not be_valid
        expect(subject.errors).to include(:direction_rate_id)
      end
    end
  end
end
