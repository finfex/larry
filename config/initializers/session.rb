# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

Rails.application.config.session_store :cookie_store, key: '_larry_session', domain: Settings.domain, tld_length: Settings.tld_length
