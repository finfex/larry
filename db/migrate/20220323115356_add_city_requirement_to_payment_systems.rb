class AddCityRequirementToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :require_city_on_income, :boolean, default: false, null: false
    add_column :gera_payment_systems, :require_city_on_outcome, :boolean, default: false, null: false
  end
end
