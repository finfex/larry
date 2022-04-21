class RemoveCustomBitfinexTickerFromCurrencies < ActiveRecord::Migration[6.1]
  def change
    remove_column :currencies, :custom_bitfinex_ticker
  end
end
