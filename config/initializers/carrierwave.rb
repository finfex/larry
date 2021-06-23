require 'carrierwave/processing/mini_magick'

CarrierWave.configure do |config|
  config.storage = :file
  # Don't use yet
  # config.asset_host = Settings.app.default_host
end
