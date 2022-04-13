# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default Settings.default_mailer.symbolize_keys
  layout 'mailer'

  private

  def t(key)
    I18n.t key, scope: :mailer
  end
end
