# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module ClearCreditCardNumber
  extend ActiveSupport::Concern

  included do
    before_validation :clear_number
  end

  private

  def clear_number
    self.number = number.chomp.strip.tr(' ', '')
  end
end
