# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module PaymentSystemConcern
  extend ActiveSupport::Concern
  included do
    has_many :wallets
    belongs_to :reservers_aggregator, class_name: 'Gera::PaymentSystem', optional: true

    monetize :reserves_delta_cents, as: :reserves_delta_amount, with_model_currency: :currency_iso_code
  end

  def reserve_amount
    @reserve_amount ||= Money.from_amount ReservesByPaymentSystems.get_reserve_by_payment_system_id(id), currency
  end
end
