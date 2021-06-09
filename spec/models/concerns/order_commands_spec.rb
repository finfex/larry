# frozen_string_literal: true

require 'rails_helper'

describe OrderCommands do
  before do
    allow_any_instance_of(Gera::CurrencyRatesRepository).to receive(:find_currency_rate_by_pair).and_return currency_rate
  end

  let(:currency_rate) { create :currency_rate, cur_from: USD, cur_to: EUR }
  let!(:aml_status) { create :aml_status, :default }
  let(:operator)       { create :user }
  let(:direction_rate) { create :direction_rate_with_active_wallets }
  let(:order)          { create :order, direction_rate: direction_rate, operator: operator }
  let(:outcome_wallet) { outcome_payment_system.wallets.take }
  let(:outcome_payment_system) { order.outcome_payment_system }
  let(:transfer) { Transfer.build(amount: order.outcome_amount.to_f, wallet_id: outcome_wallet.id) }
  let(:transfers) { [transfer] }

  it 'проверочка' do
    expect(order).to_not be_done
  end

  describe '#operator_complete_payout!' do
    context 'беcчековая ПС' do
      it 'подтверждает заявку' do
        order.operator_complete_payout!(outcome_transfers_details: transfers)
        expect(order).to be_done
      end

      it 'создает движение по счету' do
        expect do
          order.operator_complete_payout!(outcome_transfers_details: transfers)
        end.to change { WalletUpdate.count }.from(0).to(1)
      end

      context 'в кошельке недостаточно денег' do
        before do
          transfer.wallet.update!(balance: 0)
        end

        it 'падает с ошибкой' do
          expect do
            order.operator_complete_payout!(outcome_transfers_details: transfers)
          end.to raise_error(OrderCommands::PayoutError)
        end
      end
    end

    context 'чековая ПС' do
      let(:cheque_format) { 'exmo_eur' }
      before do
        outcome_payment_system.update_column :cheque_format, cheque_format
        allow(order).to receive(:validates_operator_cheques?).and_return(true)
      end

      context 'неверный формат чеков' do
        let(:cheques) { [number: 'неверный формат чека'] }

        it 'падает из-за неверного формата' do
          expect do
            order.operator_complete_payout!(outcome_transfers_details: transfers, cheques: cheques)
          end.to raise_error(ActiveRecord::RecordInvalid)

          expect(order).to_not be_done
        end
      end

      context 'верный формат чеков' do
        let(:cheques) { [number: 'EX-CODE_123_EUR123'] }

        it 'подтвеждает заявку' do
          expect do
            order.operator_complete_payout!(outcome_transfers_details: transfers, cheques: cheques)
          end.not_to raise_error

          expect(order).to be_done
        end
      end
    end
  end

  describe '#operator_create_payouts!' do
    before do
      outcome_payment_system.update!(account_format: :by_currency)
      order.update!(outcome_account: 'test_account')
    end

    context 'в кошельке достаточно денег' do
      it 'создает выплаты' do
        expect do
          order.operator_create_payouts!(transfers: transfers)
        end.to change { OrderPayout.count }.from(0).to(1)
      end
    end

    context 'в кошельке недостаточно денег' do
      before do
        outcome_wallet.update(balance: 0)
      end

      it 'падает с ошибкой' do
        expect do
          order.operator_create_payouts!(transfers: transfers)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#complete_internal_transfer!' do
    let!(:income_payment_system) { create :payment_system_with_active_wallet, currency: RUB }
    let!(:outcome_payment_system) { create :payment_system_with_active_wallet, currency: USD }
    let!(:direction_rate) do
      create :direction_rate,
             income_payment_system: income_payment_system,
             outcome_payment_system: outcome_payment_system,
             base_rate_value: 1,
             comission: 100,
             rate_value: 0.963
    end
    let(:order) do
      create :order,
             operation_type: :internal_transfer,
             income_payment_system: income_payment_system,
             outcome_payment_system: outcome_payment_system,
             direction_rate: direction_rate,
             income_wallet: income_payment_system.wallets_available_for_transfers.first,
             outcome_wallet: outcome_payment_system.wallets_available_for_transfers.last,
             income_amount: 10,
             outcome_amount: 100
    end

    it 'переводит в состояние оплачен' do
      expect(WalletUpdate).to receive(:create!).twice # приход и расход
      expect(order.transfers.count).to eq(1) # только расход
      expect(order).to be_done
    end
  end

  describe '#complete_cost!' do
    context 'заявка не является затратами' do
      let(:order) { create :order }

      it 'падает с ошибкой' do
        expect { order.send(:complete_cost!) }.to raise_error(RuntimeError, 'Заявка не является затратами')
      end
    end

    context 'заявка является затратами' do
      let!(:outcome_payment_system) { create :payment_system_with_active_wallet, account_format: :by_currency }
      let(:outcome_amount) { 100 }
      let(:order) do
        create :order,
               operation_type: :cost,
               outcome_payment_system: outcome_payment_system,
               outcome_wallet: outcome_payment_system.wallets_available_for_transfers.last,
               income_amount: nil,
               outcome_amount: 100,
               operator: create(:user)
      end

      it 'сразу переводит в состояние оплачен' do
        expect(WalletUpdate).to receive(:create!)
        order
        expect(order.transfers.count).to eq(1)
        expect(order).to be_done
      end

      it 'создает движение по счету' do
        expect { order }.to change { WalletUpdate.count }.from(0).to(1)
      end
    end
  end

  describe '#operator_confirm_income!' do
    let(:order) { create :order, operator: create(:user) }

    it 'creates wallet update on income confirmation' do
      expect { order.operator_confirm_income! }.to change { WalletUpdate.count }.from(0).to(1)
    end
  end

  describe '#operator_recover!' do
    let(:order) { create :order }
    let(:operator) { create :user }
    subject { order.operator_recover!(operator: operator) }

    context 'заявка не ошибочная' do
      it do
        expect { subject }.to raise_error(RuntimeError, 'Заявка не ошибочная')
      end
    end

    context 'заявка ошибочная' do
      before { order.reject!(reason: 'sample', status: :rejected) }

      it do
        expect(order).to be_rejected
        expect(order.text).to be_present
      end

      it do
        subject
        expect(order).to be_waiting
        expect(order.text).not_to be_present
      end
    end
  end

  describe '#operator_refund!' do
    let(:order) { create :order }
    let(:operator) { create :user }
    subject { order.operator_refund!(operator: operator) }

    it do
      expect(OrderRefund).to receive(:create!).and_return(double)
      expect { subject }.not_to raise_error
    end
  end
end
