# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class PagesController < ApplicationController
    before_action do
      @container = :fixed
    end

    def show
      page = Page.find_by!(path: params[:path])
      render locals: { page: page }
    end
  end
end
