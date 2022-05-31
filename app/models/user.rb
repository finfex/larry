# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class User < ApplicationRecord
  has_secure_password
  include Authority::Abilities

  validates :email, presence: true, uniqueness: true

  has_one :partner, dependent: :destroy
  has_many :orders, dependent: :destroy
  # has_many :user_to_credit_cards, dependent: :destroy
  # has_many :credit_cards, through: :user_to_credit_cards, dependent: :destroy
  has_many :credit_card_verifications, dependent: :destroy

  after_create :create_partner

  def public_name
    email
  end
end
