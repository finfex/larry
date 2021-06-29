# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :site_setting, class: 'SiteSettings::SiteSetting' do
    key { SiteSettings::KEYS.first }
    value { 'MyText' }
  end
end
