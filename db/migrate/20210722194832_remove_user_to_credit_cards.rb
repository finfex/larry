# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RemoveUserToCreditCards < ActiveRecord::Migration[6.1]
  def change
    drop_table :user_to_credit_cards
  end
end
