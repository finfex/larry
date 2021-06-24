# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RemoveAccountFromPartners < ActiveRecord::Migration[6.1]
  def change
    remove_column :partners, :account_id
  end
end
