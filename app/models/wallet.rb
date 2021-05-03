class Wallet < ApplicationRecord
  include CurrencySupport

  belongs_to :payment_system, class_name: '::PaymentSystem'
  belongs_to :available_account, class_name: 'OpenbillAccount'
  belongs_to :locked_account, class_name: 'OpenbillAccount'

  before_create do
    available_account ||= OpenbillAccount.create!(category_id: Settings.openbill.categories.wallets)
    locked_account ||= OpenbillAccount.create!(category_id: Settings.openbill.categories.wallets)
  end

  after_create do
    available_account.update details: "Availability account for wallet #{id}"
    locked_account.update details: "Locked account for wallet #{id}"
  end
end
