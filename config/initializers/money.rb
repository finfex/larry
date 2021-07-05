# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Money.locale_backend = :i18n
Money.default_currency = :RUB

MoneyRails.configure do |config|
  config.default_bank = Money::Bank::VariableExchange.new(Gera::CurrencyExchange)
  config.amount_column = { postfix: '_cents', type: :integer, null: false, limit: 8, default: 0, present: true }

  # default
  config.rounding_mode = BigDecimal::ROUND_HALF_EVEN
  config.default_format = {
    no_cents_if_whole: true,
    translate: true,
    drop_trailing_zeros: true
  }
end

# rubocop:disable Style/ClassAndModuleChildren
class Money::Currency
  def precision
    8
  end

  def zero_money
    0.to_money self
  end
end
# rubocop:enable Style/ClassAndModuleChildren
