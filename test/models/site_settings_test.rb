# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class SiteSettingsTest < ActiveSupport::TestCase
  def test_settings_key
    FactoryBot.create :site_setting, key: 'extra_html', value: 'value'
    assert_equal SiteSettings.extra_html, 'value'
  end
end
