# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class OrderActionDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at operator message]
  end

  def data_attribute(namespace: nil) # rubocop:disable Lint/UnusedMethodArgument
    {}
  end
end
