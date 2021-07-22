# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Log income amounts from order confirmed by operator
#
class WalletIncomeCommand < ApplicationCommand
  def call(order:, operator:)
    order.income_wallet.account.with_lock do
      users_account = OpenbillCategory.users.accounts.find_or_create_by!(amount_currency: order.income_currency)
      details = "Подтвержденное поступление средств по заявке #{order.uid}"
      wa = order
           .income_wallet
           .activities
           .create!(amount: order.income_amount,
                    wallet: order.income_wallet,
                    activity_type: :order_income,
                    details: details,
                    admin_user: operator,
                    opposit_account: users_account)

      OpenbillTransaction.create!(
        to_account: order.income_wallet.account,
        from_account: users_account,
        amount: order.income_amount,
        details: wa.details,
        meta: { wallet_activity_id: wa.id },
        key: 'wallet_activity_id:' + wa.id
      )
      wa
    end
  end
end
