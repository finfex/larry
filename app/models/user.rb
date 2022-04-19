# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class User < ApplicationRecord
  has_secure_password
  include Authority::Abilities

  validates :email, presence: true, uniqueness: true

  has_one :partner
  has_many :orders
  has_many :user_to_credit_cards
  has_many :credit_cards, through: :user_to_credit_cards
  has_many :credit_card_verifications

  ROLES = %w[superadmin operator]

  validates :role, presence: true, inclusion: { in: ROLES }

  after_create :create_partner

  def is_super_admin?
    role == 'superadmin'
  end

  def public_name
    email
  end
end
