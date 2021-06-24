# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module SiteSettings
  UnknownSettingsKey = Class.new StandardError
  class SiteSetting < ApplicationRecord
    validates :key, presence: true, uniqueness: true
  end

  def self.method_missing(key)
    ss = SiteSetting.find_by(key: key)
    return ss.value if ss.present?

    raise UnknownSettingsKey
  end

  def self.respond_to_missing?(_key)
    true
  end
end
