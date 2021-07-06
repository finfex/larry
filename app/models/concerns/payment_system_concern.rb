# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'account_address_validation'

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

    enumerize :address_format, in: AccountAddressValidation.formats

    mount_uploader :icon, PaymentSystemLogoUploader

    before_create do
      if currency.is_crypto?
        self.system_type = :crypto
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

  # rubocop:disable Metrics/MethodLength
  def address_valid?(address)
    case address_format
    when nil, ''
      address.blank?
    when :credit_card
      !AccountAddressValidation.credit_card_valid?(address.to_s, available_outcome_card_brands_list).nil?
    else
      method = "#{address_format}_valid?"
      raise "В AccountAddressValidation отсутвует метод валидации #{method}" unless AccountAddressValidation.respond_to? method

      arity = AccountAddressValidation.method(method).arity
      case arity
      when 1
        !AccountAddressValidation.send(method, address.to_s).nil?
      when 2
        !AccountAddressValidation.send(method, address.to_s, currency).nil?
      else
        raise "Unknown arity #{arity} for validation #{method}"
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
