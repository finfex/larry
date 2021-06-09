# frozen_string_literal: true

require 'rails_helper'

describe OrderHold do
  let(:user) { create :user }
  let(:payment_system) { create :payment_system }
  let(:preliminary_order) { build :preliminary_order, user: user, income_payment_system: payment_system }

  describe 'холдирование заявки, если этого требует платежная система' do
    subject { preliminary_order.perform_hold }

    context 'платежная система не требует холдирования' do
      it 'ничего не делает' do
        expect { subject }.not_to change(preliminary_order, :status)
      end
    end

    context 'платежная система требует холдирование' do
      before { payment_system.update!(requires_hold: true) }

      context 'у пользователя уже есть заявки с этого кошелька' do
        before do
          allow(preliminary_order).to receive(:user_has_success_orders_with_income_account?).and_return(true)
        end

        it 'ничего не далает' do
          expect { subject }.not_to change(preliminary_order, :status)
        end
      end

      it 'устанавливает статус hold' do
        expect { subject }.to change(preliminary_order, :status).from('waiting').to('hold')
      end
    end
  end
end
