module Operator
  class PaymentSystemsController < ApplicationController
    include ArchivableActions

    authorize_actions_for PaymentSystem

    # TODO наладить smart_input и добавить reservers_aggregator
    EDIT_COLUMNS = %i[name priority currency_iso_code is_available income_enabled outcome_enabled icon_url commission minimal_income_amount minimal_outcome_amount maximal_income_amount maximal_outcome_amount bestchange_key reserves_delta]

    def index
    end

    def new
      render locals: { payment_system: PaymentSystem.new, edit_columns: EDIT_COLUMNS }
    end

    def show
      redirect_to edit_operator_payment_system_path(resource)
    end

    def edit
      render :edit, locals: { payment_system: resource, edit_columns: EDIT_COLUMNS }
    end

    def update
      resource.update! params.require(:payment_system).permit!
      redirect_to operator_payment_system_path(resource), notice: "Изменения приняты"
    rescue ActiveRecord::RecordInvalid  => error
      edit
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
