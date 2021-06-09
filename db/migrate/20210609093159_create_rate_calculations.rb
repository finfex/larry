class CreateRateCalculations < ActiveRecord::Migration[6.1]
  def change
    create_table :rate_calculations, id: :uuid do |t|
      t.decimal "income_amount_cents", default: 0, null: false
      t.string "income_amount_currency", default: "USD", null: false
      t.decimal "outcome_amount_cents", default: 0, null: false
      t.string "outcome_amount_currency", default: "USD", null: false
      t.references "direction_rate", null: false, type: :uuid, foreign_key: { to_table: :gera_direction_rates }
      t.integer "direction", default: 0, null: false
      t.decimal "suggested_income_amount_cents"
      t.boolean "require_reserves", default: false
      t.boolean "invalid_maximal_income_requirements", default: false
      t.boolean "invalid_minimal_income_requirements", default: false
      t.decimal "maximal_income_amount_cents"
      t.decimal "minimal_income_amount_cents"
      t.decimal "rate_value", null: false
      t.decimal "base_rate_value", null: false
      t.decimal "rate_percent", null: false
      t.json "direction_rate_dump", null: false
      t.timestamps
    end

    add_reference :orders, :rate_calculation, null: false, type: :uuid
  end
end
