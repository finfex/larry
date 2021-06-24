# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Authentication
  class UsersController < ApplicationController
    def new
      render locals: { user: User.new }
    end

    def create
      user = User.new permitted_params
      user.save!
      redirect_to welcome_url, notice: 'Вы зарегитсрированы'
    rescue ActiveRecord::RecordInvalid
      render :new, locals: { user: user }
    end

    private

    def permitted_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
