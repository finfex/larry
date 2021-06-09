module Operator
  class PaymentSystemsController < ApplicationController
    include ArchivableActions

    authorize_actions_for PaymentSystem

    # TODO наладить smart_input и добавить reservers_aggregator
    EDIT_COLUMNS = %i[name priority currency_iso_code is_available income_enabled outcome_enabled icon_url commission minimal_income_amount minimal_outcome_amount maximal_income_amount maximal_outcome_amount bestchange_key reserves_delta]

    def index
    end

    def new
      @resource ||= PaymentSystem.new
      render :new, locals: { payment_system: resource, edit_columns: EDIT_COLUMNS }
    end

    def show
      redirect_to edit_operator_payment_system_path(resource)
    end

    def edit
      render :edit, locals: { payment_system: resource, edit_columns: EDIT_COLUMNS }
    end

    def update
      resource.update! payment_system_params
      redirect_to operator_payment_system_path(resource), notice: "Изменения приняты"
    rescue ActiveRecord::RecordInvalid  => error
      edit
    end

    def create
      @resource = PaymentSystem.new payment_system_params
      resource.save!
      redirect_to operator_payment_system_path(resource), notice: "Платежная система создана"
    rescue ActiveRecord::RecordInvalid => error
      new
    end

    private

    def success_redirect
      redirect_to operator_payment_systems_path
    end

    def resource
      @resource ||= PaymentSystem.find params[:id]
    end

    def payment_system_params
      params.require(:payment_system).permit!
    end
  end
end
