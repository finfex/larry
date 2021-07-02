# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Create partner reward from order
class RewardCommand < ApplicationCommand
  def call(order)
    partner_account = order.referrer.accounts.find_by!(currency: order.income_currency)
    system_account = OpenbillCategory.system.accounts.find_or_create_by!(currency: order.income_currency)
    partner_account.with_lock do
      OpenbillTransaction.create!(
        to_account: parnter_account,
        from_account: system_account,
        amount: order.referrer_reward,
        details: "Partner reward for order #{order.uid}",
        meta: { order_id: order.id },
        key: 'reward_order_id:' + order.id
      )
    end
  end
end
