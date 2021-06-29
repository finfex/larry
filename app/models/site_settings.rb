# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module SiteSettings
  UnknownKey = Class.new StandardError
  KEYS = %w[extra_html].freeze
  class SiteSetting < ApplicationRecord
    validates :key, presence: true, uniqueness: true, inclusion: { in: KEYS }
  end

  def self.method_missing(key)
    raise SiteSettings::UnknownKey, key.to_s unless KEYS.include? key.to_s

    SiteSetting.find_by(key: key).try :value
  end

  def self.respond_to_missing?(key, _options)
    super || KEYS.include?(key)
  end
end
