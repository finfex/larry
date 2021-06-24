# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateSiteSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :site_settings, id: :uuid do |t|
      t.string :key, null: false
      t.text :value

      t.timestamps
    end

    add_index :site_settings, :key, unique: true
  end
end
