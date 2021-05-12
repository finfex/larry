# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class PagesController < ApplicationController
    before_action do
      @container = :fixed
    end

    def index; end

    def show
      # TODO: Find page
    end
  end
end
