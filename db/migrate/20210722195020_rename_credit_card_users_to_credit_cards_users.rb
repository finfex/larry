# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RenameCreditCardUsersToCreditCardsUsers < ActiveRecord::Migration[6.1]
  def change
    rename_table :credit_card_users, :credit_cards_users
  end
end
