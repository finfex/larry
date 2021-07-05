# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class UserDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at public_name email orders partner_ref_token partner_orders partner_balances partner_accruals partner_order_based_income_amounts]
  end

  def partner_ref_token
    return h.middot if partner.nil?

    h.link_to partner.ref_token, partner.referal_url, target: :_blank
  end

  def partner_orders
    return h.middot if partner.nil?

    h.link_to partner.orders.by_state(:done).count, h.operator_orders_path(q: { referrer_id_eq: user.partner.id, by_state: :done })
  end

  def partner_order_based_income_amounts
    return h.middot if partner.nil?

    h.render 'balances', balances: partner.orders.by_state(:done).group(:based_income_amount_currency).sum(:based_income_amount_cents)
  end

  def orders
    h.link_to user.orders.count, h.operator_orders_path(q: { user_id_eq: user.id })
  end

  def partner_balances
    h.render 'partner_balances', accounts: object.partner.accounts if object.partner.present?
  end

  def partner_accruals
    h.render 'partner_accruals', partner: object.partner if object.partner.present?
  end
end
