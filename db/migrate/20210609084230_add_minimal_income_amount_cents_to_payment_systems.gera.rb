# This migration comes from gera (originally 20210609083541)
class AddMinimalIncomeAmountCentsToPaymentSystems < ActiveRecord::Migration[5.2]
  def change
    add_column :gera_payment_systems, :minimal_income_amount_cents, :decimal, default: 0, null: false
    add_column :gera_payment_systems, :maximal_income_amount_cents, :decimal
    add_column :gera_payment_systems, :minimal_outcome_amount_cents, :decimal
    add_column :gera_payment_systems, :maximal_outcome_amount_cents, :decimal
  end
end
