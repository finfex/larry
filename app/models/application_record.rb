# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend BatchPurger

  def self.database_size
    database_name = connection.instance_variable_get("@config")[:database]
    sql = "SELECT pg_size_pretty(pg_database_size('#{database_name}'));"
    connection.execute(sql)[0]["pg_size_pretty"]
  end

  def self.vacuum
    connection.execute "vacuum full #{table_name}"
  end
end
