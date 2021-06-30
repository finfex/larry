# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module PaymentSystemConcern
  extend ActiveSupport::Concern
  included do
    has_many :wallets
    scope :by_currency, ->(currency) { where(currency_iso_code: currency.iso_code) }

    belongs_to :reservers_aggregator, class_name: 'Gera::PaymentSystem', optional: true

    monetize :reserves_delta_cents, as: :reserves_delta, with_model_currency: :currency_iso_code

    enum system_type: %i[payment_system crypto bank cheque], _prefix: true
    validates :bestchange_key, presence: true, uniqueness: true

    mount_uploader :icon, PaymentSystemLogoUploader

    before_create do
      system_type == :crypto if currency.is_crypto?
    end

    after_create do
      # TODO: generate default address
      # Wallet.create! payment_system: self, details: "Default wallet for #{name} (#{self.currency})", address: generate
      OpenbillCategory.storno.accounts.create! details: "Storno account for #{self}", reference: self, amount: self.currency.zero_money
    end
  end

  def archive!
    super
    # TODO: Stop if there are active orders
    wallets.find_each(&:archive!)
  end

  def storno_account
    OpenbillCategory.storno.accounts.where(reference: self).take
  end

  def reserve_amount
    @reserve_amount ||= Money.new ReservesByPaymentSystems.get_reserve_by_payment_system_id(id), currency
  end
end
