# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class ApplicationController < ApplicationController
    layout 'public'

    before_action do
      @container = :fixed
    end
  end
end
