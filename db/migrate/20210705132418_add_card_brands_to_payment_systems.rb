class AddCardBrandsToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :available_outcome_card_brands, :string, null: false, default: ''
  end
end
