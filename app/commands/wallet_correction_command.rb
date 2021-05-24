# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# make correction in wallet balance
#
class WalletCorrectionCommand < ApplicationCommand
  def call(wallet:, attrs:, admin_user:)
    wallet.available_account.with_lock do
      opposit_account = wallet.payment_system.storno_account
      wa = wallet.activities.create! attrs.merge(admin_user: admin_user, opposit_account: opposit_account)

      raise if wa.amount.zero?

      if wa.amount.positive?
        to_account = wallet.available_account
        from_account = opposit_account
      else
        to_account = opposit_account
        from_account = wallet.available_account
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
