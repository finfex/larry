# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class PaymentSystemLogoUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  # Create different versions of your uploaded files:
  # version   :thumb do
  # process :scale => [32, 32]
  # end

  def extension_white_list
    %w[jpg jpeg gif png svg]
  end

  def default_url(*_args)
    '/images/fallback/' + [version_name, 'payment_system.png'].compact.join('_')
  end
end
