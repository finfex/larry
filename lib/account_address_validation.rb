# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Валидации различного вида адресов счетов
#
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/ModuleLength
module AccountAddressValidation
  def self.formats
    methods
      .select { |m| m.to_s.ends_with? '_valid?' }
      .map { |m| m.to_s.gsub('_valid?', '') }
      .map(&:to_sym)
  end

  def self.by_currency_valid?(address, currency)
    if [BTC, USDT].include?(currency)
      bitcoin_valid? address
    elsif [ETH, ETC].include?(currency)
      ethereum_valid? address
    elsif currency == BCH
      bitcoin_cash_valid? address
    elsif currency == XRP
      ripple_valid? address
    elsif currency == XMR
      monero_valid? address
    elsif currency == DSH
      dash_valid? address
    elsif currency == LTC
      litecoin_valid? address
    elsif currency == ZEC
      zcash_valid? address
    elsif currency == NEO
      neo_valid? address
    else
      true
    end
  end

  def self.credit_card_valid?(address, brands = [])
    CreditCardValidations::Detector.new(address).valid?(*brands)
  end

  # Валидации кошельков в legacy
  # https://github.com/alfagen/kassa-legacy/blob/98d415691ca8d84e6e289c3f338f543e8651c4c9/app/components/ticketsproc/model.php#L2070
  def self.monero_valid?(address)
    # https://monero.stackexchange.com/questions/1502/what-do-monero-addresses-have-in-common
    address =~ /[a-zA-Z0-9]{95,106}$/
  end

  def self.ethereum_valid?(address)
    # /^(0x){1}[0-9a-fA-F]{40}$/
    Eth::Utils.valid_address? address
  end

  def self.bitcoin_valid?(address)
    Bitcoin.valid_address? address
  end

  # https://gist.github.com/miracle2k/8141380
  def self.ripple_valid?(address)
    address =~ /^[a-zA-Z0-9]{33,34}$/
  end

  def self.okpay_valid?(address)
    address =~ /^OK[0-9]{7,11}$/
  end

  def self.bitcoin_cash_valid?(address)
    Bitcoin.valid_address?(address) || Bitcoin.valid_address?(Cashaddress.to_legacy(address))

    # Бывает внутри Bitcoin-а - https://app.bugsnag.com/alfa-genesis/admin-dot-kassa-dot-cc/errors/5b253b63800146001ae13c3c?filters[event.since][0]=30d&filters[error.status][0]=open
  rescue Cashaddress::Error, TypeError
    false
  end

  def self.litecoin_valid?(address)
    address =~ /^[LM3][a-km-zA-HJ-NP-Z1-9]{26,33}$/
  end

  def self.dash_valid?(address)
    address =~ /^[X7][a-zA-Z0-9]{26,44}$/
  end

  # TODO: проверять с использованием Base58Check https://github.com/zcash/zcash/issues/2010
  def self.zcash_valid?(address)
    address =~ /^t[a-zA-Z0-9]{26,44}$/
  end

  def self.neo_valid?(address)
    address =~ /^A[a-zA-Z0-9]{33}$/
  end

  def self.advcash_valid?(address, currency)
    prefix = { RUB => 'r', USD => 'u', EUR => 'e' }[currency] || raise("Unsupported currency '#{currency}'")
    address =~ /^#{prefix}( ?\d{4}){3}$/i
  end

  def self.payeer_valid?(address)
    address =~ /^[Pp][0-9]{6,10}$/
  end

  def self.g_valid?(address)
    address =~ /^[0-9]{2,7}$/
  end

  def self.alfaclick_valid?(address)
    address.length == 20
  end

  def self.telebank_valid?(address)
    address.length == 20
  end

  def self.qiwi_valid?(address)
    address = '7' + address if address.start_with?('9') && address.length == 10
    Phonelib.valid? address
  end

  def self.yandex_money_valid?(address)
    address =~ /^[0-9]{10,16}$/
  end

  def self.perfect_money_valid?(address, currency)
    prefix = { USD => 'u', EUR => 'e' }[currency] || raise("Unsupported currency '#{currency}'")
    address =~ /^#{prefix}[0-9]{7,8}$/i
  end

  def self.exmo_rub_cheque_valid?(cheque_number)
    cheque_number =~ /EX-CODE_\d+_RUB[\w\-_]+/
  end

  def self.exmo_usd_cheque_valid?(cheque_number)
    cheque_number =~ /EX-CODE_\d+_USD[\w\-_]+/
  end

  def self.exmo_eur_cheque_valid?(cheque_number)
    cheque_number =~ /EX-CODE_\d+_EUR[\w\-_]+/
  end

  def self.evoucher_cheque_valid?(cheque_number, pin)
    cheque_number !~ /\D/ && pin !~ /\D/
  end
end
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/ModuleLength
