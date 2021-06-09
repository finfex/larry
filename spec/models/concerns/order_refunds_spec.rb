# frozen_string_literal: true

require 'rails_helper'

describe OrderRefunds do
  let(:operator) { create :user }
  let(:order) { create :order, operator: operator }
  before do
    order.operator_confirm_income!
    allow(order).to receive(:able_to_refund?).and_return(true)
  end

  describe '#refund_money' do
    it 'return sum of refunds amount' do
      expect(order.refund_money).to be_zero
    end

    context 'order has refunds' do
      before do
        allow_any_instance_of(OrderRefund).to receive(:perform_worker!).and_return(nil)
        create_list :order_refund, 3, order: order, state: :processing
      end

      it 'return sum of refunds amount' do
        expect(order.refund_money).to eq(OrderRefund.all.sum(&:amount))
      end
    end
  end

  describe '#accept_refund!' do
    context 'when refund is not complete' do
      it 'does not update refund_state' do
        order.accept_refund!
        expect(order).not_to be_refund_state_succeed
      end
    end

    context 'when refund is complete' do
      before do
        allow(order).to receive(:refund_complete?).and_return(true)
      end

      it 'updates refund_state' do
        expect(order).not_to be_refund_state_succeed
        order.accept_refund!
        expect(order).to be_refund_state_succeed
      end
    end
  end
end
