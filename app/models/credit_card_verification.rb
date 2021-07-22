# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreditCardVerification < ApplicationRecord
  include ClearCreditCardNumber

  belongs_to :user, optional: true
  belongs_to :order, optional: true
  has_one :credit_card, foreign_key: :verification_id

  validates :number, credit_card_number: true, presence: true
  validates :image, presence: true
  validates :full_name, presence: true

  mount_uploader :image, CreditCardUploader

  scope :by_state, ->(state) { where state: state }

  state_machine :state, initial: :pending do
    event :process do
      transition pending: :processing
    end

    event :accept do
      transition %i[processing pending] => :accepted
      # TODO: create CreditCard
    end

    event :reject do
      transition %i[processing pending] => :rejected
    end

    after_transition on: :accept, do: :link_card!
    after_transition on: :accept, do: :mark_verified_order!
  end

  def self.ransackable_scopes(_auth)
    %i[by_state]
  end

  def mark_verified_order!
    return if order.nil?

    order.verified!
  end

  def link_card!
    credit_card = CreditCard.find_by(number: number) ||
                  create_credit_card!(
                    number: number,
                    full_name: full_name
                  )
    credit_card.users << user unless credit_card.users.include? user
  end
end
