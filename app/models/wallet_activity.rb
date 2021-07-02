# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletActivity < ApplicationRecord
  include Authority::Abilities
  belongs_to :wallet
  belongs_to :opposit_account, class_name: 'OpenbillAccount'
  belongs_to :admin_user

  monetize :amount_cents, as: :amount, numericality: { greater_than: 0 }

  validates :details, presence: true
  validates :amount, presence: true
  validates :activity_type, presence: true

  ACTIVITY_TYPES = %i[correction order_income].freeze # , :deposit, :withdrawal]
  MANUAL_ACTIVITY_TYPES = %i[correction].freeze
  enum activity_type: ACTIVITY_TYPES
end
