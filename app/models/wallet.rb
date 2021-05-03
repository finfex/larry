class Wallet < ApplicationRecord
  include CurrencySupport

  belongs_to :payment_system, class_name: '::PaymentSystem'

  monetize :amount_cents, with_model_currency: :currency_code
  monetize :locked_cents, with_model_currency: :currency_code
  monetize :total_cents, with_model_currency: :currency_code

  validates :currency_code do
    errors.add :currency_code, 'Must be equeal to payment system currencn' unless payment_system.currency == currency
  end
end
