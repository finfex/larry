# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Wallet < ApplicationRecord
  include CurrencySupport
  include Archivable

  belongs_to :payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :account, class_name: 'OpenbillAccount'

  has_many :activities, class_name: 'WalletActivity'

  delegate :currency, to: :payment_system

  validates :address, presence: true, uniqueness: { scope: :payment_system_id }

  before_validation on: :create, if: :payment_system, unless: :account do
    create_account!(
      category_id: Settings.categories.fetch(:wallets),
      amount_currency: payment_system.currency.iso_code
    )
  end

  after_create do
    account.update details: "Availability account for wallet #{id}", reference: self
  end

  def available_amount
    account.amount
  end

  def to_s
    [name, address].join(' ')
  end

  def name
    payment_system.wallet_name
  end
end
