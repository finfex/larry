class Currency < ApplicationRecord
  include Archivable
  include Authority::Abilities

  has_many :payment_systems, foreign_key: :currency_iso_code, primary_key: :id, class_name: 'Gera::PaymentSystem'

  monetize :minimal_input_value_cents, with_model_currency: :id
  monetize :minimal_output_value_cents, with_model_currency: :id

  alias_attribute :iso_code, :id

  delegate :is_crypto?, to: :money_currency

  def money_currency
    Money::Currency.find id
  end

  def archive!
    super
    payment_systems.alive.find_each &:archive!
  end
end
