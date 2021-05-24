# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# make correction in wallet balance
#
class WalletCorrectionCommand < ApplicationCommand
  def call(wallet:, attrs:, admin_user:)
    wallet.available_account.transaction do
      opposit_account = wallet.payment_system.storno_account
      wa = wallet.activities.create! attrs.merge(admin_user: admin_user, opposit_account: opposit_account)

      raise if amount.zero?

      if amount.positive?
        income_account = wallet.available_account
        outcome_account = opposit_account
      else
        income_account = opposit_account
        outcome_account = wallet.available_account
      end

      OpenbillTransaction.create!(
        income_account: income_account,
        outcome_account: outcome_account,
        amount: wa.amount,
        details: details,
        meta: { wallet_activity_id: wa.id }
      )
      wa
    end
  end
end
