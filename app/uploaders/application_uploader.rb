# frozen_string_literal: true

class ApplicationUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include SecureUniqueFilename
  include FileDetails

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  # Create different versions of your uploaded files:
  version :thumb do
    process :scale => [32, 32]
  end

  def store_dir
    "uploads/#{model.class.model_name.collection}/#{model.id}/#{mounted_as}"
  end
end
