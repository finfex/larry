# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Application uploader
#
class ApplicationUploader < CarrierWave::Uploader::Base
  include SecureUniqueFilename
  include FileDetails

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  def store_dir
    "uploads/#{model.class.model_name.collection}/#{model.id}/#{mounted_as}"
  end
end
