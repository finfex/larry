class AddRequireVerifyIncomeCardToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :require_verify_income_card, :boolean, null: false, default: false
  end
end
