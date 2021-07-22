# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RemoveExpirationDatesFromCard < ActiveRecord::Migration[6.1]
  def change
    remove_column :credit_card_verifications, :exp_month
    remove_column :credit_card_verifications, :exp_year
    remove_column :credit_cards, :exp_month
    remove_column :credit_cards, :exp_year
  end
end
