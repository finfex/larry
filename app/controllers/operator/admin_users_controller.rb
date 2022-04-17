# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class AdminUsersController < ApplicationController
    include ArchivableActions

    helper_method :resource

    def show
      render locals: { admin_user: resource }
    end

    def edit
    end

    def update
      resource.update! payment_system_params
      redirect_to operator_payment_system_path(resource), notice: 'Изменения приняты'
    rescue ActiveRecord::RecordInvalid
      edit
    end

    def create
      resource.update! payment_system_params
      redirect_to operator_payment_system_path(resource), notice: 'Изменения приняты'
    rescue ActiveRecord::RecordInvalid
      edit
    end

    def index
      render locals: { admin_users: paginate(AdminUser.order('email desc')) }
    end

    private

    def resource
      @resource ||= AdminUser.find(params[:id])
    end

    def payment_system_params
      params.require(:admin_user).permit(:email, :password, :telegarm_id)
    end
  end
end
