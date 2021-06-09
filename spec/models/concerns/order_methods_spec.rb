# frozen_string_literal: true

require 'rails_helper'

describe OrderMethods do
  let(:direction_rate) { create :direction_rate_with_active_wallets }
  let(:order)          { create :order, direction_rate: direction_rate, operator: create(:user) }

  describe '#complete!' do
    it do
      expect(order).to_not be_done
    end

    it 'подтверждает заявку' do
      order.complete!
      expect(order).to be_done
    end
  end

  describe '#accept_payout!' do
    let(:order_payout) { create :order_payout }
    before { order.process_payout! }

    it do
      expect(order).to_not be_done
    end

    it 'создает движение по счету' do
      expect { order.accept_payout!(order_payout) }.to change { WalletUpdate.count }.from(0).to(1)
    end

    context 'автоматическая выплата' do
      before { order_payout.update(operator: nil) }

      it 'создает движение по счету с комментарием об автоматической выплате' do
        order.accept_payout!(order_payout)
        wallet_update = WalletUpdate.last
        expect(wallet_update.details).to include('Автоматическая выплата')
      end
    end

    context 'выплата меньше суммы долга' do
      it 'не подтверждает заявку' do
        order.accept_payout!(order_payout)
        expect(order).not_to be_done
        expect(order).not_to be_payout_status_succeed
      end
    end

    context 'выплата равна сумме долга' do
      let(:order_payout) { create :order_payout, amount: order.outcome_money }

      it 'подтверждает заявку' do
        order.accept_payout!(order_payout)
        expect(order).to be_done
        expect(order).to be_payout_status_succeed
      end
    end
  end
end
