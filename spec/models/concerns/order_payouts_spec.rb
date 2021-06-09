# frozen_string_literal: true

require 'rails_helper'

describe OrderPayouts do
  let(:order) { create :order, outcome_account: '123' }

  describe '#create_auto_payout!' do
    subject { order.create_auto_payout! }

    it 'создает выплату' do
      expect { subject }.to change { OrderPayout.count }.from(0).to(1)
    end

    it 'выплата на сумму заявки на выходной кошлелек' do
      subject
      order_payout = OrderPayout.last
      expect(order_payout.wallet).to eq(order.outcome_wallet)
      expect(order_payout.amount).to eq(order.outcome_money)
    end
  end
end
