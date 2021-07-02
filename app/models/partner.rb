# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Partner < ApplicationRecord
  belongs_to :user

  has_many :orders, foreign_key: :referrer_id
  has_many :accounts, class_name: 'OpenbillAccount'

  enum accrual_method: %i[income profit]

  before_create do
    self.ref_token = SecureRandom.hex(12)
  end

  delegate :public_name, to: :user

  after_create do
    Currency.all.alive.each do |currency|
      OpenbillCategory.partners.accounts.create!(
        details: "Partner account for #{self} with #{currency}",
        reference: self,
        amount: currency.zero_money
      )
    end
  end

  def referal_url
    Rails.application.routes.url_helpers.public_root_url(ref_token: ref_token)
  end

  def accounts
    OpenbillCategory.partners.accounts.where(reference: self)
  end

  def to_s
    public_name
  end
end
