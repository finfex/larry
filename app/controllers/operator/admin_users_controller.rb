# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class AdminUsersController < ApplicationController
    before_action do
      @container = :fluid
    end

    helper_method :resource

    def show
      render locals: { admin_user: resource }
    end

    def index
      render locals: { admin_users: paginate(AdminUser.order('email desc')) }
    end

    private

    def resource
      @resource ||= AdminUser.find(params[:id])
    end
  end
end
