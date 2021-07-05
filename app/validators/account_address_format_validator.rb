# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class AccountAddressFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    payment_system = object.send(payment_system_option) || raise("Отсутсвует платежная система для валидации формата кошелька #{payment_system_option}")

    return if payment_system.address_valid? value.to_s

    object.errors.add attribute, options[:message] || t(payment_system.id) || payment_system.wrong_address_format_message || t(:default)
  end

  private

  def t(key)
    I18n.t(key, scope: %i[validators account_format wrong], default: key == :default ? nil : t(:default))
  rescue I18n::ArgumentError => e
    Rails.logger.error e
    Bugsnag.notify e do |b|
      b.meta_data = { key: key }
    end
    "Wrong account number #{key}"
  end

  def payment_system_option
    options[:payment_system] || raise('Отсутствует опция payment_system')
  end
end
