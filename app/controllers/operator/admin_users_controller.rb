# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class AdminUsersController < ApplicationController
    include ArchivableActions

    helper_method :admin_user

    before_action only: %i[create new] do
      raise Unauthenticated unless current_admin_user.is_super_admin?
    end

    before_action only: %i[update edit] do
      raise Unauthenticated if admin_user != current_admin_user && !current_admin_user.is_super_admin?
    end

    def show
      render locals: { admin_user: admin_user }
    end

    def new
      render :new, locals: { admin_user: AdminUser.new }
    end

    def edit
      render :edit, locals: { admin_user: admin_user }
    end

    def update
      admin_user.update! permitted_params
      flash[:notice] = 'Изменения приняты'
      edit
    rescue ActiveRecord::RecordInvalid
      edit
    end

    def create
      AdminUser.create! permitted_params
      redirect_to operator_admin_users_path, notice: 'Изменения приняты'
    rescue ActiveRecord::RecordInvalid => err
      render :new, locals: { admin_user: err.record }
    end

    def index
      render locals: { admin_users: paginate(AdminUser.order('email desc')) }
    end

    private

    def admin_user
      @admin_user ||= AdminUser.find(params[:id])
    end

    def permitted_attributes
      list = %i[email password telegram_id]
      list << %i[is_super_admin] if current_admin_user.is_super_admin?
      list
    end

    def permitted_params
      params.require(:admin_user).permit( *permitted_attributes )
    end
  end
end
