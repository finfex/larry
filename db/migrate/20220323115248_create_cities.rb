class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :cities, :name, unique: true
  end
end
