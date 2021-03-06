# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module MoneyHelper
  MAX_PRECISION = 8

  def humanized_money_with_currency(money, text_if_empty: '-', thousands_separator: '')
    return text_if_empty if money.nil?

    # money.format(with_currency: true, symbol: false)
    symbol = "<span class='text-muted'>#{money.currency}</span></span>".html_safe
    "<span class=\"text-nowrap text-monospace\">#{money.format(symbol: symbol, format: '%n %u', decimal_mark: '.',
                                                               thousands_separator: thousands_separator)}</span>".html_safe
  end

  def present_fee(fee, amount = nil)
    content_tag :span, class: 'text-nowrap text-monospace' do
      buffer = (fee * 100).to_s + '%'
      buffer << amount * fee if amount
      buffer
    end
  end

  def format_divergence(amount, currency)
    if amount.zero?
      content_tag :span, class: 'text-success' do
        t('helpers.no_divergence')
      end
    else
      format_money amount, currency, css_class: 'text-warning', tooltip: 'Должно быть 0'
    end
  end

  def compare_amounts(estimated, actual)
    return [:nagative, actual - estimated] if estimated > actual
    return [:positive, actual - estimated] if actual > estimated

    nil
  end

  # @param amount [Decimal, String, Money]
  # @param currency [Currency, String]
  # @param options [Hash] :tooltip, :css_class, :show_currency
  def format_money(amount, currency = nil, options = {})
    amount = amount.to_d if amount.is_a? String
    if amount.is_a? Money
      currency = amount.currency
      amount = amount.to_d
    end
    options = options.symbolize_keys.reverse_merge show_currency: true
    currency = currency.is_a?(Money::Currency) ? currency : Money::Currency.find(currency)
    css_classes = %w[text-nowrap text-monospace]
    css_classes << options[:css_class]
    buffer = money_precission(amount, currency.precision)
    buffer += format_currency(currency, css_class: 'text-muted ml-1') if options[:show_currency] && !amount.nil?
    content_tag :span, class: css_classes.join(' '), title: options[:tooltip], data: { toggle: :tooltip } do
      buffer.html_safe
    end
  end

  def money_precission(amount, precision)
    return middot if amount.nil?
    return '0' if amount.zero?
    return amount.to_i.to_s if amount.to_i == amount

    precised = format("%0.#{precision}f", amount)
    return precised if precised.to_d == amount

    format("%0.#{MAX_PRECISION}f", amount)
  end

  def format_currency(currency_id, css_class: '')
    content_tag :span, currency_id.to_param, class: "text-uppercase text-monospace #{css_class}"
  end
end
