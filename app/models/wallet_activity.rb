# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletActivity < ApplicationRecord
  belongs_to :wallet
  belongs_to :opposit_account, class_name: 'OpenbillAccount'
  belongs_to :author, class_name: 'AdminUser'

  monetize :amount_cents, as: :amount, with_model_currency: :currency

  validates :details, presence: true
  validates :amount, presence: true

  delegate :currency, to: :wallet

  after_initialize { |wa| wa.amount = currency.zero_money }
end
