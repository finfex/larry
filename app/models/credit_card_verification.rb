# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreditCardVerification < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :order, optional: true

  validates :number, credit_card_number: true, presence: true
  validates :image, presence: true
  validates :exp_month, presence: true
  validates :exp_year, presence: true
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
  end

  def self.ransackable_scopes(_auth)
    %i[by_state]
  end
end
