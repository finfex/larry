# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require './db/seeds/currencies'
require './db/seeds/gera'
require './db/seeds/openbill'
require './db/seeds/users'

SiteSettings.enabled=true
SiteSettings.work_start_hm='00:00'
SiteSettings.work_finish_hm='00:00'

Gera::RateSource.find_by(type: 'Gera::RateSourceBitfinex').update_supported_tickers!
