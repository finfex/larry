# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class PartnersController < ApplicationController
    authorize_actions_for Partner
    helper_method :resource

    def show
      render locals: { user: Partner.find(params[:id]) }
    end

    def update
      partner.update! params.require(:partner).permit!
      redirect_to operator_user_path(partner.user), notice: 'Изменения приняты'
    rescue ActiveRecord::RecordInvalid
      render 'operator/users/show', locals: { user: partner.user }
    end

    private

    def partner
      @partner ||= Partner.find params[:id]
    end

    def resource
      partner.user
    end
  end
end
