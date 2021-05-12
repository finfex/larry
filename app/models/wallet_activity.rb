# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletActivity < ApplicationRecord
  belongs_to :wallet
  belongs_to :opposit_account, class_name: 'OpenbillAccount'
  belongs_to :author, class_name: 'AdminUser'

  validates :details, presence: true
end
