# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

Rails.application.reloader.to_prepare do
  AppVersion, HumanizedError, Settings, ActionText::ContentHelper, ActionText::TagHelper # rubocop:disable Lint/Syntax
  #
end
