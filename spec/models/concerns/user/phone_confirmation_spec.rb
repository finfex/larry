# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'rails_helper'

describe User::PhoneConfirmation do
  subject { create :user }

  it { expect(subject).to_not be_phone_confirmed }
  it { expect(subject.phone_confirmation_pincode).to be_nil }
  it { expect(subject.phone_confirmation_pincode_generated_at).to be_nil }
  it { expect(subject.confirmed_phone).to be_nil }

  context 'пин-код отправляется автоматически' do
    it 'отправляется пин-код если задается телефон' do
      expect(SmsWorker).to receive(:perform_async)
      subject.update phone: generate(:phone)
    end

    it 'при создании тоже отправляется' do
      expect(SmsWorker).to receive(:perform_async)

      create :user, phone: generate(:phone)
    end
  end

  context 'устанавливаем и подтверждаем телефон' do
    let(:phone) { generate :phone }

    before do
      subject.update phone: phone
    end

    it { expect(subject).to_not be_phone_confirmed }
    it { expect(subject.phone_confirmation_pincode).to_not be_nil }
    it { expect(subject.phone_confirmation_pincode_generated_at).to_not be_nil }
    it { expect(subject.confirmed_phone).to be_nil }

    context 'при смене телефона пинкод меняется' do
      before do
        @saved_pincode = subject.phone_confirmation_pincode
        subject.update phone: generate(:phone)
      end

      it { expect(subject.phone_confirmation_pincode).to_not eq @saved_pincode }
    end

    context 'подтверждаем pincode' do
      before do
        subject.phone_confirm! subject.phone_confirmation_pincode
      end

      it { expect(subject).to be_phone_confirmed }
      it { expect(subject.confirmed_phone).to eq phone }
      it { expect(subject.phone_confirmation_pincode).to be_nil }
      it { expect(subject.phone_confirmation_pincode_generated_at).to be_nil }

      it 'второй раз подтвердить не получится' do
        expect { subject.phone_confirm! subject.phone_confirmation_pincode }.to raise_error User::PhoneConfirmation::WrongPinCode
      end
    end
  end

  context 'пользователь создается с телефоном' do
    let(:phone) { generate :phone }
    subject { create :user, phone: phone }

    it { expect(subject).to_not be_phone_confirmed }
    it { expect(subject.phone_confirmation_pincode).to_not be_nil }
    it { expect(subject.phone_confirmation_sent_at).to_not be_nil }
    it { expect(subject.phone_confirmation_pincode_generated_at).to_not be_nil }
    it { expect(subject.confirmed_phone).to be_nil }

    context 'меняем телефон' do
      let(:new_phone) { generate :phone }
      context 'телефон еще не подтвержден' do
        let(:elapsed_seconds) { 10.seconds }
        before do
          @phone_confirmation_sent_at = subject.phone_confirmation_sent_at
          Timecop.freeze Time.zone.now + elapsed_seconds do
            subject.update phone: new_phone
          end
        end

        it { expect(subject).to_not be_phone_confirmed }
        it { expect(subject.phone_confirmation_pincode).to_not be_nil }
        it { expect(subject.phone_confirmation_pincode_generated_at).to_not be_nil }
        it { expect(subject.phone_confirmation_sent_at).to_not eq @phone_confirmation_sent_at }
        it do
          expect(subject.next_phone_confirmation_request_available_timeout).to be >= elapsed_seconds
        end
      end

      context 'телефон уже подтвержден' do
        before do
          subject.phone_confirm! subject.phone_confirmation_pincode
          @phone_confirmation_sent_at = subject.phone_confirmation_sent_at
          subject.update phone: new_phone
        end

        it { expect(subject.phone_confirmation_pincode).to_not be_nil }
        it { expect(subject.phone_confirmation_pincode_generated_at).to_not be_nil }

        it { expect(subject.phone_confirmation_sent_at).to_not eq @phone_confirmation_sent_at }

        context 'возвращаем подтвержденный телефон и все становится назад' do
          before do
            subject.update phone: phone
          end
          it { expect(subject).to be_phone_confirmed }
          it { expect(subject.confirmed_phone).to eq phone }
        end
      end
    end
  end
end
