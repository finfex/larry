# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'carrierwave/processing/mini_magick'

CarrierWave.configure do |config|
  config.storage = :file
  # Don't use yet
  # config.asset_host = Settings.app.default_host
end
