# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Currency < ApplicationRecord
  include Archivable
  include Authority::Abilities

  has_many :payment_systems, foreign_key: :currency_iso_code, primary_key: :id, class_name: 'Gera::PaymentSystem'

  monetize :minimal_input_value_cents, with_model_currency: :id
  monetize :minimal_output_value_cents, with_model_currency: :id

  alias_attribute :iso_code, :id

  delegate :zero_money, :is_crypto?, to: :money_currency

  def self.find_by_money_currency(money_currency)
    find_by iso_code: money_currency.iso_code
  end

  def money_currency
    Money::Currency.find id
  end

  def archive!
    super
    payment_systems.alive.find_each(&:archive!)
  end
end
