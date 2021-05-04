# frozen_string_literal: true

Money.locale_backend = :i18n

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

class Money::Currency
  def precision
    8
  end
end
