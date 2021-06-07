module Operator
  class CurrenciesController < ApplicationController
    include ArchivableActions

    authorize_actions_for Currency

    def index
    end

    private

    def success_redirect
      redirect_to operator_currencies_path
    end

    def resource
      @currency ||= Currency.find params[:id]
    end
  end
end
