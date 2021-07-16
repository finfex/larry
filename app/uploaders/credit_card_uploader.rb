# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Uploader for payment system logo
class CreditCardUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  # Create different versions of your uploaded files:
  # version   :thumb do
  # process :scale => [32, 32]
  # end

  def extension_white_list
    %w[jpg jpeg gif png]
  end

  def default_url(*_args)
    '/images/fallback/' + [version_name, 'credit_card.png'].compact.join('_')
  end
end
