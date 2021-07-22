# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Operator
  class PaymentSystemsController < ApplicationController
    include ArchivableActions

    authorize_actions_for Gera::PaymentSystem

    before_action do
      @container = :fluid
    end

    # TODO: наладить smart_input и добавить reservers_aggregator
    EDIT_COLUMNS = %i[
      name priority currency_iso_code is_available income_enabled outcome_enabled icon commission minimal_income_amount
      minimal_outcome_amount maximal_income_amount maximal_outcome_amount bestchange_key reserves_delta
      wallet_name address_format wrong_address_format_message
      require_full_name_on_income require_full_name_on_outcome
      require_email_on_income require_email_on_outcome
      require_verify_income_card
    ].freeze

    def index; end

    def show
      redirect_to edit_operator_payment_system_path(resource)
    end

    def new
      @resource ||= Gera::PaymentSystem.new
      render :new, locals: { payment_system: resource, edit_columns: EDIT_COLUMNS }
    end

    def edit
      render :edit, locals: { payment_system: resource, edit_columns: EDIT_COLUMNS }
    end

    def update
      resource.update! payment_system_params
      redirect_to operator_payment_system_path(resource), notice: 'Изменения приняты'
    rescue ActiveRecord::RecordInvalid
      edit
    end

    def create
      @resource = Gera::PaymentSystem.new payment_system_params
      resource.save!
      redirect_to operator_payment_system_path(resource), notice: 'Платежная система создана'
    rescue ActiveRecord::RecordInvalid
      new
    end

    private

    def model_class
      Gera::PaymentSystem
    end

    def success_redirect
      redirect_to operator_payment_systems_path
    end

    def resource
      @resource ||= Gera::PaymentSystem.find params[:id]
    end

    def payment_system_params
      params.require(:payment_system).permit!
    end
  end
end
