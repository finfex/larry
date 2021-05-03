# frozen_string_literal: true

class Wallet < ApplicationRecord
  include CurrencySupport

  belongs_to :payment_system, class_name: '::PaymentSystem'
  belongs_to :available_account, class_name: 'OpenbillAccount'
  belongs_to :locked_account, class_name: 'OpenbillAccount'

  def self.create_for_payment_system!(payment_system)
    Wallet.transaction do
      available_account = OpenbillAccount.create!(category_id: Settings.openbill.categories.wallets)
      locked_account = OpenbillAccount.create!(category_id: Settings.openbill.categories.wallets)
      wallet = create! payment_system: payment_system, available_account: available_account, locked_account: locked_account
      available_account.update details: "Availability account for wallet #{wallet.id}", reference: wallet
      locked_account.update details: "Locked account for wallet #{wallet.id}", reference: wallet
      wallet
    end
  end
end
