# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletActivityDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at amount activity_type details opposit_account admin_user]
  end

  %i[amount].each do |method|
    define_method method do
      h.format_money object.send(method)
    end
  end

  def admin_user
    object.admin_user.name
  end

  def opposit_account
    object.opposit_account.details
  end
end
