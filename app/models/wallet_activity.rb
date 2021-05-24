# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletActivity < ApplicationRecord
  include Authority::Abilities
  belongs_to :wallet
  belongs_to :opposit_account, class_name: 'OpenbillAccount'
  belongs_to :admin_user

  monetize :amount_cents, as: :amount, with_model_currency: :currency

  validates :details, presence: true
  validates :amount, presence: true
  validates :activity_type, presence: true

  ACTIVITY_TYPES = [:correction] #, :deposit, :withdrawal]
  enum activity_type: ACTIVITY_TYPES

  delegate :currency, to: :wallet

  after_initialize { |wa| wa.amount ||= currency.zero_money }
end
