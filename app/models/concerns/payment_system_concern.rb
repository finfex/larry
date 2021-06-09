# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module PaymentSystemConcern
  extend ActiveSupport::Concern
  included do
    has_many :wallets
  end

  # TODO create attribute in database
  def bestchange_letter_cod
    'test'
  end
end
