# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

FactoryBot.define do
  factory :site_setting, class: 'SiteSettings::SiteSetting' do
    key { 'widget' }
    value { 'MyText' }
  end
end
