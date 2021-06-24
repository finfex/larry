# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'settingslogic'
if defined? Rails
  class Settings < Settingslogic
    source Rails.root.join('config', 'settings.yml')
    namespace Rails.env
    suppress_errors Rails.env.production?
  end
else
  class Settings < Settingslogic
    source './config/settings.yml'
    namespace 'development'
  end
end

class Settings
  def domain
    default_url_options.host
  end

  def tld_length
    default_url_options.host.split('.').count - 1
  end
end
