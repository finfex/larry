# This migration comes from gera (originally 20220323084716)
class AddNotNullOfMaximalAndMinimalAmounts < ActiveRecord::Migration[5.2]
  def change
    change_column_default :gera_payment_systems, :maximal_income_amount_cents, 1000
    change_column_default :gera_payment_systems, :maximal_outcome_amount_cents, 1000
    change_column_default :gera_payment_systems, :minimal_outcome_amount_cents, 1

    Gera::PaymentSystem.update_all maximal_income_amount_cents: 1000, maximal_outcome_amount_cents: 1000, minimal_outcome_amount_cents: 1

    change_column_null :gera_payment_systems, :maximal_income_amount_cents, false
    change_column_null :gera_payment_systems, :maximal_outcome_amount_cents, false
    change_column_null :gera_payment_systems, :minimal_outcome_amount_cents, false
  end
end
