class AddAddressFormaToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :address_format, :string

    Gera::PaymentSystem.find_each { |ps| ps.update! system_type: :crypto if ps.currency.is_crypto? }
    Gera::PaymentSystem.where(system_type: :crypto).find_each { |ps| ps.update! address_format: 'by_currency' }
  end
end
