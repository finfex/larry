# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Create partner reward from order
class RewardCommand < ApplicationCommand
  def call(order:)
    partner_account = order.referrer.accounts.find_by!(amount_currency: order.income_currency.iso_code)

    system_account = OpenbillCategory.system.accounts
                                     .create_with(amount_cents: 0)
                                     .find_or_create_by!(amount_currency: order.income_currency.iso_code)

    order.with_lock do
      order
        .actions
        .create!(key: :reward,
                 custom_message: "Выплачено вознаграждение пратнеру #{order.referrer} в размере #{order.referrer_reward.format}")
      OpenbillTransaction.create!(
        to_account: partner_account,
        from_account: system_account,
        amount: order.referrer_reward,
        details: "Partner reward for order #{order.uid}",
        meta: { order_id: order.id },
        key: 'reward_order_id:' + order.id
      )
    end
  end
end
