# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Wallet < ApplicationRecord
  include CurrencySupport
  include Archivable

  belongs_to :payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :available_account, class_name: 'OpenbillAccount'
  belongs_to :locked_account, class_name: 'OpenbillAccount'

  has_many :activities, class_name: 'WalletActivity'

  delegate :currency, to: :payment_system

  validates :address, presence: true, uniqueness: { scope: :payment_system_id }

  before_validation on: :create, if: :payment_system do
    self.available_account ||= OpenbillAccount
                               .create!(category_id: Settings.openbill.categories.wallets, amount_cents: 0,
                                        amount_currency: payment_system.currency.iso_code)
    self.locked_account ||= OpenbillAccount
                            .create!(category_id: Settings.openbill.categories.wallets, amount_cents: 0,
                                     amount_currency: payment_system.currency.iso_code)
  end

  after_create do
    available_account.update details: "Availability account for wallet #{id}", reference: self
    locked_account.update details: "Locked account for wallet #{id}", reference: self
  end

  def available_amount
    available_account.amount
  end

  def locked_amount
    locked_account.amount
  end

  def total_amount
    available_amount + locked_amount
  end

  def name
    payment_system.wallet_name
  end
end
