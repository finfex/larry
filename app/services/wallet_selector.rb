# Select income and outcome wallets
#
class WalletSelector
  Error = Class.new StandardError
  NoIncomeWallet = Class.new Error
  NoOutcomeWallet = Class.new Error

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def select_income_wallet
    order.income_payment_system.wallets.alive.where(income_enabled: true).take ||
      raise(NoIncomeWallet, "No available income wallet for #{order.income_payment_system.id})")
  end

  def select_outcome_wallet
    order.outcome_payment_system.wallets.alive.where(outcome_enabled: true).take ||
      raise(NoIncomeWallet, "No available outcome wallet for #{order.income_payment_system.id})")
  end
end
