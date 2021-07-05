# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'rails_helper'

describe Validations do
  context 'advcash usd' do
    subject { Validations.advcash_valid? address, USD }
    [
      'U 0354 6788 2220',
      'u 0354 6788 2221',
      'U789091134779'
    ].each do |value|
      context "value=#{value}" do
        let(:address) { value }
        it { expect(subject).to be_truthy }
      end
    end
  end

  context 'payeer' do
    subject { Validations.payeer_valid? address }
    [
      'P39219692'
    ].each do |value|
      context "value=#{value}" do
        let(:address) { value }
        it { expect(subject).to be_truthy }
      end
    end
  end
  context 'bitcoin' do
    subject { Validations.bitcoin_valid? address }

    [
      '18Vvptk3wUMk64kacnFSBWMv5GtWHGPNLF'
    ].each do |value|
      context "value=#{value}" do
        let(:address) { value }
        it { expect(subject).to be_truthy }
      end
    end

    describe 'не валидный не падает' do
      let(:address) { 'bitcoincash:qr94gcse7czjhzzrys73puwzn2n07p2gnu5mggp79c' }
      it { expect(subject).to_not be_truthy }
    end
  end

  context 'monero' do
    subject { Validations.monero_valid? address }

    %w[
      9sCrDesy9LK11111111111111111111111111111111112N1GuTZeagfRbbKcALdcZev4QXGGuoLh2x36LhaxLSxCZ3Viua
      9wm6oNA5nP3LnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjTDpKXAE
      A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfufSYUchQ8hH2R272H
    ].each do |value|
      context "value=#{value}" do
        let(:address) { value }
        it { expect(subject).to be_truthy }
      end
    end
  end

  context 'ripple' do
    subject { Validations.ripple_valid? address }

    [
      '50dc2d6de07e8c76ab25a2cca4b4a9bf9f'
    ].each do |value|
      context "value=#{value}" do
        let(:address) { value }
        it { expect(subject).to be_truthy }
      end
    end
  end

  context 'litecoin' do
    subject { Validations.litecoin_valid? address }
    [
      'LMRGEqXUUzGXT4AYdZNw1UxETmNP1XsFoN'
    ].each do |value|
      context "value=#{value}" do
        let(:address) { value }
        it { expect(subject).to be_truthy }
      end
    end
  end

  context 'dash' do
    subject { Validations.dash_valid? address }

    %w[
      XmzgzKSournZBFCG19ZHv3cFVamm6CwYcR
      7fePc8Mf7RYghdxkSp5yaWfT9WR4F2Dsqa
    ].each do |value|
      context "value=#{value}" do
        let(:address) { value }
        it { expect(subject).to be_truthy }
      end
    end

    context 'value=gfePc8Mf7RYghdxkSp5yaWfT9WR4F2Dsqa' do
      let(:address) { 'gfePc8Mf7RYghdxkSp5yaWfT9WR4F2Dsqa' }
      it { expect(subject).to be_falsy }
    end
  end

  context 'zcash' do
    subject { Validations.zcash_valid? address }

    %w[
      t1mzgzKSournZBFCG19ZHv3cFVamm6CwYcR
      t2ePc8Mf7RYghdxkSp5yaWfT9WR4F2Dsqa
    ].each do |value|
      context "value=#{value}" do
        let(:address) { value }
        it { expect(subject).to be_truthy }
      end
    end

    context 'value=gfePc8Mf7RYghdxkSp5yaWfT9WR4F2Dsqa' do
      let(:address) { 'gfePc8Mf7RYghdxkSp5yaWfT9WR4F2Dsqa' }
      it { expect(subject).to be_falsy }
    end
  end

  context 'cheques' do
    describe 'exmo_rub' do
      subject { Validations.exmo_rub_cheque_valid?(cheque_number) }

      context 'valid cheque_number' do
        let(:cheque_number) { 'EX-CODE_86845_RUB074b4cd015b53a26af49467b24b18853c2bc9975' }
        it { expect(subject).to be_truthy }
      end

      context 'invalid cheque_number' do
        let(:cheque_number) { '074b4cd015b53a26af49467b24b18853c2bc9975' }
        it { expect(subject).to be_falsy }
      end
    end
    describe 'exmo_usd' do
      subject { Validations.exmo_usd_cheque_valid?(cheque_number) }

      context 'valid cheque_number' do
        let(:cheque_number) { 'EX-CODE_86845_USD074b4cd015b53a26af49467b24b18853c2bc9975' }
        it { expect(subject).to be_truthy }
      end

      context 'invalid cheque_number' do
        let(:cheque_number) { '074b4cd015b53a26af49467b24b18853c2bc9975' }
        it { expect(subject).to be_falsy }
      end
    end
    describe 'evoucher' do
      subject { Validations.evoucher_cheque_valid?(cheque_number, cheque_pin) }

      context 'valid cheque_number' do
        let(:cheque_number) { '2398741230987' }
        let(:cheque_pin) { '92347923' }
        it { expect(subject).to be_truthy }
      end

      context 'invalid cheque_number' do
        let(:cheque_number) { '23987a41230987' }
        let(:cheque_pin) { '923z47923' }
        it { expect(subject).to be_falsy }
      end
    end
  end
end
