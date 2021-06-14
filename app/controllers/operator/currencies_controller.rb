# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Operator
  class CurrenciesController < ApplicationController
    include ArchivableActions

    authorize_actions_for Currency

    def index; end

    private

    def success_redirect
      redirect_to operator_currencies_path
    end

    def resource
      @resource ||= Currency.find params[:id]
    end
  end
end
