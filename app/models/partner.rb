# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Partner < ApplicationRecord
  belongs_to :user
  belongs_to :account, class_name: 'OpenbillAccount'

  before_create do
    self.ref_token = SecureRandom.hex(12)
  end

  after_create do
    Currency.all.alive.each do |currency|
      OpenbillCategory.partners.accounts.create!(
        details: "Partner account for #{self} with #{currency}",
        reference: self,
        amount: currency.zero_money
      )
    end
  end

  def to_s
    "Partner #{user}"
  end
end
