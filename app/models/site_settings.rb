# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module SiteSettings
  UnknownSettingsKey = Class.new StandardError
  KEYS = %w[extra_html].freeze
  class SiteSetting < ApplicationRecord
    validates :key, presence: true, uniqueness: true, inclusion: { in: KEYS }
  end

  def self.method_missing(key)
    ss = SiteSetting.find_by(key: key)
    return ss.value if ss.present?

    raise SiteSettings::UnknownSettingsKey unless KEYS.include? key.to_s
  end

  def self.respond_to_missing?(key, _options)
    super || KEYS.include?(key)
  end
end
