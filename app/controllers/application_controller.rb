# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper NotyFlash::ApplicationHelper
  helper Gera::CurrencyRateHelper
  layout 'simple'
end
