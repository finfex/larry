# frozen_string_literal: true

module PaymentSystemConcern
  extend ActiveSupport::Concern
  included do
    has_many :wallets
  end
end
