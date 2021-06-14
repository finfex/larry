# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'rails_helper'

describe OrderConfirmation do
  before do
    allow_any_instance_of(PreliminaryOrder).to receive(:validate_direction_enabled)
    allow_any_instance_of(Gera::PaymentSystem).to receive(:has_enough_reserves?).and_return true
  end

  let(:preliminary_order) { create :preliminary_order }

  describe '#operator_confirm' do
    subject { preliminary_order.operator_confirm!(operator: create(:user)) }

    it do
      expect(subject).to be_a Order
      expect(subject.confirmed_at).to be_a Time
      expect(preliminary_order).to be_destroyed
    end
  end

  describe '#auto_confirm!' do
    subject { preliminary_order.auto_confirm!(income_amount: preliminary_order.income_money) }

    it 'созадет заявку из временной' do
      expect_any_instance_of(Order).not_to receive(:create_auto_payout!)
      expect(subject).to be_a(Order)
      expect(preliminary_order).to be_destroyed
    end

    it 'updates wallet balance' do
      before_balance = preliminary_order.income_wallet.balance

      order = subject

      after_balance = order.income_wallet.reload.balance
      diff = after_balance - before_balance

      expect(diff).to eq preliminary_order.income_amount
    end

    context 'auto_payout_enabled' do
      before do
        preliminary_order.exchange_rate.update!(auto_payout_enabled: true)
      end

      it 'созадет автоматическую выплату' do
        expect_any_instance_of(Order).to receive(:create_auto_payout!)
        subject
      end
    end
  end
end
