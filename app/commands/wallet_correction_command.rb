# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Make wallets balance correction
#
class WalletCorrectionCommand < ApplicationCommand
  def call(wallet:, admin_user:, amount:, details:)
    wallet.account.with_lock do
      opposit_account = wallet.payment_system.storno_account
      wa = wallet.activities.create!(
        activity_type: :correction,
        details: details,
        amount: amount,
        admin_user: admin_user,
        opposit_account: opposit_account
      )

      raise if wa.amount.zero?

      if wa.amount.positive?
        to_account = wallet.account
        from_account = opposit_account
      else
        to_account = opposit_account
        from_account = wallet.account
      end

      OpenbillTransaction.create!(
        to_account: to_account,
        from_account: from_account,
        amount: wa.amount,
        details: wa.details,
        meta: { wallet_activity_id: wa.id },
        key: 'wallet_activity_id:' + wa.id
      )
      wa
    end
  end
end
