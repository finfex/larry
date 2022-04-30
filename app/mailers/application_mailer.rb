# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: -> { SiteSettings.mail_from },
    delivery_method_options: -> { SiteSettings.smtp_settings.symbolize_keys }

  layout 'mailer'

  helper :application
  helper :money
  helper :rate
  helper :mailer

  private

  def t(key)
    I18n.t key, scope: :mailer
  end
end
