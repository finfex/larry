# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class PagesController < ApplicationController
    def show
      page = Page.find_by!(path: params[:path])
      render locals: { page: page }
    end
  end
end
