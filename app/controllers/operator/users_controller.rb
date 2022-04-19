# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class UsersController < ApplicationController
    authorize_actions_for User
    before_action do
      @container = :fluid
    end

    helper_method :resource

    def show
      render locals: { user: resource }
    end

    def index
      render locals: { users: paginate(User.includes(:partner).order('created_at desc')) }
    end

    private

    def resource
      @resource ||= User.find(params[:id])
    end
  end
end
