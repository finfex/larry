# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class SiteSettings < ApplicationRecord
  UnknownKey = Class.new StandardError
  FIELDS = Settings.site_settings.stringify_keys
  DEFAULTS = Settings.site_settings_defaults.stringify_keys
  KEYS = FIELDS.keys

  TYPES = %w[email string text integer hm boolean].freeze

  INPUT_TYPE = {
    'email'   => 'email',
    'string'  => 'string',
    'text'    => 'text',
    'integer' => 'numeric',
    'hm'      => 'string',
    'boolean' => 'boolean'
  }

  include Authority::Abilities
  validates :key, presence: true, uniqueness: true, inclusion: { in: KEYS }
  validates :value_type, presence: true, inclusion: { in: TYPES }

  validate :validate_value

  def self.method_missing(key)
    get(key).value
  end

  def self.get(key)
    raise SiteSettings::UnknownKey, key.to_s unless KEYS.include? key.to_s

    SiteSettings.
      create_with(value_type: FIELDS.fetch(key.to_s), value: DEFAULTS.fetch(key.to_s,nil)).
      find_or_create_by!(key: key)
  end

  def self.respond_to_missing?(key, _options)
    super || KEYS.include?(key)
  end

  def self.smtp_settings
    KEYS.each_with_object({}) do |key, agg|
      agg[key.gsub('smtp_settings_','')] = get(key).value if key.to_s.include? 'smtp_settings_'
    end
  end

  def self.is_work_time?
    now = Time.zone.now
    start = Time.zone.parse(work_start_hm, now)
    finish = Time.zone.parse(work_finish_hm, now)
    return true if start==finish

    start < now && now < finish
  end


  def value
    case value_type
    when 'integer'
      super.to_i
    when 'boolean'
      !!super
    else
      super
    end
  end

  def input_type
    INPUT_TYPE.fetch value_type
  end

  def title
    I18n.t key, scope: :site_settings, default: key
  end

  private

  def validate_value
    case value_type
    when 'hm'
      errors.add :value, 'Должно быть в формате HH:MM' unless value=~/^(\d{2}):(\d{2})$/
      Time.parse(value, Time.now) rescue errors.add(:value, 'Должно быть в формате HH:MM')
    end
  end
end
