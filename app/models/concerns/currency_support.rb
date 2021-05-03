module CurrencySupport
  def currency
    return unless currency_iso_code

    Money::Currency.find(currency_iso_code) || raise("No currency found #{currency_iso_code}")
  end

  def currency=(value)
    self.currency_iso_code = if value.blank?
                               nil
                             elsif value.is_a? Money::Currency
                               value.local_id
                             else
                               (Money::Currency.find(value) || raise("No currency found #{value}")).local_id
                             end
    currency
  end
end
