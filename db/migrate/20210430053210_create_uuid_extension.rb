# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateUuidExtension < ActiveRecord::Migration[6.1]
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS pgcrypto;'
  end
end
