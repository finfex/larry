# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Observe reserces by currencies
#
class ReservesByCurrencies
  def wallets_balances
    @wallets_balances ||= Wallet
      .alive
      .joins(:available_account)
      .group(:amount_currency)
      .sum(:amount_cents)
      .map { |k, v| c=Money::Currency.find(k); [c, Money.new(v, c)] }
      .to_h
  end

  def final_reserves
    @final_reserves ||= wallets_balances
  end

  def delta
    {}
  end
end
