# frozen_string_literal: true

class Wallet < ApplicationRecord
  include CurrencySupport

  belongs_to :payment_system, class_name: '::PaymentSystem'
  belongs_to :available_account, class_name: 'OpenbillAccount'
  belongs_to :locked_account, class_name: 'OpenbillAccount'

  has_many :activities, class_name: 'WalletActivity'

  delegate :currency, to: :payment_system

  def self.create_for_payment_system!(payment_system)
    Wallet.transaction do
      available_account = OpenbillAccount.create!(category_id: Settings.openbill.categories.wallets, amount_cents: 0, amount_currency: payment_system.currency.iso_code)
      locked_account = OpenbillAccount.create!(category_id: Settings.openbill.categories.wallets, amount_cents: 0, amount_currency: payment_system.currency.iso_code)
      wallet = create! payment_system: payment_system, available_account: available_account, locked_account: locked_account,
                       details: "Wallet for #{payment_system.name} (#{payment_system.currency})"
      available_account.update details: "Availability account for wallet #{wallet.id}", reference: wallet
      locked_account.update details: "Locked account for wallet #{wallet.id}", reference: wallet
      wallet
    end
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
end
