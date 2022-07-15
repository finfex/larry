# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version')

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'caxlsx', '~> 3.0'
gem 'caxlsx_rails'

gem "redis-actionpack", "~> 5.2"
gem 'redis-store'
gem 'redis-rails'

gem 'auto_strip_attributes'
gem 'bitcoin-ruby', require: 'bitcoin'
gem 'cashaddress'
gem 'credit_card_validations'
gem 'date_validator'
gem 'nilify_blanks'
gem 'valid_email' # , require: 'valid_email/validate_email'
# gem 'eth'

# базы данных
gem 'carrierwave'
gem 'enumerize'
gem 'enum_help'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'auto_logger'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bugsnag'
gem 'dapi-archivable', require: 'archivable'
gem 'env-tweaks', '~> 1.0.0'
gem 'foreman'
gem 'gera', path: 'vendor/gera' # github: 'finfex/gera', branch: 'master'
gem 'gravatarify', '~> 3.1'
gem 'kaminari', '~> 1.2'
gem 'money'
gem 'money-rails'
gem 'noty_flash', github: 'BrandyMint/noty_flash' # for gera
gem 'percentable'
gem 'psych', '< 4.0'
gem 'rails-i18n', '~> 6.0'
gem 'ruby-progressbar'
gem 'semver2', '~> 3.4'
gem 'sidekiq-unique-jobs'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'simple_form'
gem 'slim-rails'
gem 'state_machines-activerecord'

gem 'dotenv'
gem 'dotenv-rails'

group :development, :test do
  gem 'letter_opener_web'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'guard'
  gem 'guard-minitest'
  gem 'guard-rubocop'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop-rails'
end

group :development do
  gem 'scss-lint'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
group :deploy do
  gem 'bugsnag-capistrano', require: false
  gem 'capistrano', require: false
  gem 'capistrano3-puma'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-dotenv-tasks'
  gem 'capistrano-faster-assets', require: false
  gem 'capistrano-git-with-submodules'
  gem 'capistrano-master-key', require: false, github: 'virgoproz/capistrano-master-key'
  gem 'capistrano-nvm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-shell', require: false
  gem 'capistrano-systemd-multiservice', github: 'brandymint/capistrano-systemd-multiservice', require: false
  gem 'capistrano-yarn', require: false
end

gem 'title', '~> 0.0.8'

gem 'active_link_to', '~> 1.0'

gem 'authority', '~> 3.3'

gem 'factory_bot', '~> 6.1'
gem 'factory_bot_rails'

gem 'breadcrumbs_on_rails', '~> 4.1'

gem 'draper', '~> 4.0'

gem 'best_in_place', git: 'https://github.com/mmotherwell/best_in_place'

gem 'ransack', '~> 2.4'

gem 'rails_warden', github: 'wardencommunity/rails_warden'
gem 'warden', '~> 1.2'

gem 'sd_notify', '~> 0.1.1'

gem 'hairtrigger', '~> 0.2.24'

gem "phonelib", "~> 0.6.57"

gem "telegram-bot", "~> 0.15.6"

gem "strip_attributes", "~> 1.12"

gem "coffee-rails", "~> 5.0"

gem 'cocoon'

gem "request_store-sidekiq", "~> 0.1.0"
