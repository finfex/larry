# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CurrencyDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[iso_code]
  end
end
