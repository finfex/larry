module Operator
  class PaymentSystemsController < ApplicationController
    include ArchivableActions

    authorize_actions_for PaymentSystem

    def index
    end

    def show
      render locals: { payment_system: resource }
    end

    def edit
      render locals: { payment_system: resource }
    end

    private

    def success_redirect
      redirect_to operator_payment_systems_path
    end

    def resource
      @currency ||= PaymentSystem.find params[:id]
    end
  end
end
