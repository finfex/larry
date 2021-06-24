# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class OpenbillCategory < OpenbillRecord
  has_many :accounts, class_name: 'OpenbillAccount', foreign_key: :category_id

  has_many :income_transactions, through: :accounts
  has_many :outcome_transactions, through: :accounts

  class << self
    Settings.openbill.categories.each_pair do |key, id|
      define_method key do
        OpenbillCategory.create_with(name: key).find_or_create_by!(id: id)
      end
    end
  end
end
