class CreateCurrencies < ActiveRecord::Migration[6.1]
  def change
    create_table :currencies, id: :string do |t|
      t.timestamp :archived_at
      t.timestamp :updated_at
      t.decimal :minimal_input_value_cents, null: false
      t.decimal :minimal_output_value_cents, null: false
    end
  end
end
