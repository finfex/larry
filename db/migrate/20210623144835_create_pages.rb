# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages, id: :uuid do |t|
      t.string :path, null: false
      t.string :menu_title, null: false
      t.string :html_title, null: false

      t.timestamps
    end

    add_index :pages, :path, unique: true
  end
end
