# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class SiteSettingTest < ActiveSupport::TestCase
  def test_settings_key
    FactoryBot.create :site_setting, key: 'key', value: 'value'
    assert_equal SiteSettings.key, 'value'
  end
end
