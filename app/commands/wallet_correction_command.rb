# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletCorrectionCommand < ApplicationCommand
  def call(wallet:, attrs:, admin_user:)
    opposit_account = wallet.payment_system.storno_account
    wallet.activities.create! attrs.merge(admin_user: admin_user, opposit_account: opposit_account)
  end
end
