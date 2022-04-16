class AddBitfinexTickerToCurrencyes < ActiveRecord::Migration[6.1]
  def change
    add_column :currencies, :custom_bitfinex_ticker, :string
  end
end
