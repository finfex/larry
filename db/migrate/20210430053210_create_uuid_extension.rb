class CreateUuidExtension < ActiveRecord::Migration[6.1]
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS pgcrypto;'
  end
end
