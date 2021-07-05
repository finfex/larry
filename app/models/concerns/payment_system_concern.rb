# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'validations'

module PaymentSystemConcern
  extend ActiveSupport::Concern
  included do
    extend Enumerize

    has_many :wallets
    has_many :booked_amounts

    belongs_to :reservers_aggregator, class_name: 'Gera::PaymentSystem', optional: true

    scope :by_currency, ->(currency) { where(currency_iso_code: currency.iso_code) }

    monetize :reserves_delta_cents, as: :reserves_delta, with_model_currency: :currency_iso_code

    enum system_type: %i[payment_system crypto bank cheque], _prefix: true

    validates :bestchange_key, presence: true, uniqueness: true

    # Брать доступные меотды из Validations
    ADDRESS_FORMATS = %i[by_currency credit_card okpay advcash payeer telebank alfaclick qiwi yandex_money perfect_money none].freeze
    enumerize :address_format, in: ADDRESS_FORMATS

    mount_uploader :icon, PaymentSystemLogoUploader

    before_create do
      if currency.is_crypto?
        self.system_type == :crypto
        self.address_format = 'by_currency'
      end
    end

    after_create do
      # TODO: generate default address
      # Wallet.create! payment_system: self, details: "Default wallet for #{name} (#{self.currency})", address: generate
      OpenbillCategory.storno.accounts.create! details: "Storno account for #{self}", reference: self, amount: self.currency.zero_money
    end
  end

  def total_booked_amounts
    Money.new(booked_amounts.sum(:amount_cents) || 0, currency)
  end

  def total_amount
    Money.new(
      wallets
      .alive
      .where(outcome_enabled: true)
      .joins(:account)
      .sum(:amount_cents) || 0,
      currency
    )
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

  def available_outcome_card_brands_list
    available_outcome_card_brands
      .to_s
      .split(/\s*,\s*/)
  end

  def address_valid?(address)
    case address_format.to_s
    when :none
      address.blank?
    when :credit_card
      !!Validations.credit_card_valid?(address.to_s, available_outcome_card_brands_list)
    else
      method = "#{address_format}_valid?"
      raise "В Validations отсутвует метод валидации #{method}" unless Validations.respond_to? method

      arity = Validations.method(method).arity
      if arity == 1
        !!Validations.send(method, address.to_s)
      elsif arity == 2
        !!Validations.send(method, address.to_s, currency)
      else
        raise "Unknown arity #{arity} for validation #{method}"
      end
    end
  end
end
