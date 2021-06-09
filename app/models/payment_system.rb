# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

PaymentSystem = Gera::PaymentSystem

class PaymentSystem
  scope :by_currency, -> (currency)  { where(currency_iso_code: currency.iso_code) }

  has_one :wallet

  def archive!
    super
    wallet.archive!
  end

  def storno_account
    OpenbillCategory.storno.accounts.where(reference: self).take
  end
end
