# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddRejectMessageToCreditCardVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_card_verifications, :reject_message, :string
  end
end
