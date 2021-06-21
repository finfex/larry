# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class OpenbillService < ApplicationRecord
  belongs_to :account, class_name: 'OpenbillAccount'
  has_many :vendor_services, dependent: :delete_all
  has_many :openbill_transactions

  validates :title, uniqueness: true
end
