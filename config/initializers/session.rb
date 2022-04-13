# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

Settings = Rails.configuration.settings
domain = Settings.default_url_options.fetch(:host)
tld_length = Settings.default_url_options.fetch(:host).split('.').count - 1

Rails.application.config.session_store :cookie_store, key: '_larry_session', domain: domain, tld_length: tld_length

ActionDispatch::Http::URL.tld_length = tld_length
