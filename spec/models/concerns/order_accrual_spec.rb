# frozen_string_literal: true

require 'rails_helper'

describe OrderAccrual do
  let(:outcome_amount) { Money.new(10_000, RUB) }
  let(:outcome_payment_system) { create :payment_system, :with_active_wallet }
  let(:order) do
    create :preliminary_order,
           income_amount: nil,
           outcome_payment_system: outcome_payment_system,
           operation_type: :cashback,
           outcome_amount: outcome_amount,
           unpaid_referral_histories: ReferralsHistory.all
  end
  before do
    create_list :referrals_history, 2
    allow(outcome_payment_system).to receive(:has_enough_reserves?).and_return(true)
    allow_any_instance_of(AmountInCurrencies).to receive(:get_amounts).and_return(RUB => outcome_amount)
  end

  describe 'валидация суммы на вывод реферальных' do
    context 'сумма не указана в ПС' do
      it do
        expect(order).to be_valid
      end
    end

    context 'сумма указана в ПС' do
      let(:diff) { Money.new(100, RUB) }
      context 'сумма на вывод меньше минимальной' do
        before do
          outcome_payment_system.update!(minimal_accrual_outcome_amount: outcome_amount + diff)
        end

        it do
          expect { order }.to raise_error(ActiveRecord::RecordInvalid, 'Возникли ошибки: Исходящая сумма Минимальная сумма для вывода: 101 ₽')
        end
      end

      context 'сумма на вывод больше минимальной' do
        before do
          outcome_payment_system.update!(minimal_accrual_outcome_amount: outcome_amount - diff)
        end

        it do
          expect(order).to be_valid
        end
      end
    end
  end
end
