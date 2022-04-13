# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default Settings.default_mailer.symbolize_keys
  layout 'mailer'

  helper :application
  helper :'money_rails/action_view_extension'

  private

  def t(key)
    I18n.t key, scope: :mailer
  end
end
