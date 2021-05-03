module CurrencySupport
  def currency
    return unless currency_iso_code

    Money::Currency.find(currency_iso_code) || raise("No currency found #{currency_iso_code}")
  end

  def currency=(value)
    if value.blank?
      self.currency_iso_code = nil
    elsif value.is_a? Money::Currency
      self.currency_iso_code = value.local_id
    else
      self.currency_iso_code = (Money::Currency.find(value) || raise("No currency found #{value}")).local_id
    end
    self.currency
  end
end
