# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class OpenbillCategory < OpenbillRecord
  has_many :accounts, class_name: 'OpenbillAccount', foreign_key: :category_id

  has_many :income_transactions, through: :accounts
  has_many :outcome_transactions, through: :accounts

  def self.storno
    OpenbillCategory.find_by(name: 'storno')
  end
end
