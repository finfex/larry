# frozen_string_literal: true

require 'rails_helper'

describe OrderSaveUserWallets do
  describe '#save_user_wallets' do
    subject(:save_wallets) { order.save_user_wallets }

    let(:order) do
      build(
        :order,
        income_account: '123123123',
        outcome_account: '987987987',
        income_payment_system: create(:payment_system),
        outcome_payment_system: create(:payment_system)
      )
    end

    it 'creates two wallets' do
      expect { save_wallets }.to change(UserWallet, :count).from(0).to(2)
    end

    context "when order has no user accounts" do
      let(:order) { build :order }

      it 'do nothing' do
        expect { save_wallets }.not_to change(UserWallet, :count)
      end
    end
  end
end
