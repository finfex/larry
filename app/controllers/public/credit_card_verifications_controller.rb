# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Public
  class CreditCardVerificationsController < ApplicationController
    before_action :unauthenticated!, unless: :authenticated?

    def new
      render locals: { ccv: CreditCardVerification.new }
    end

    def index
      redirect_to public_credit_cards_path
    end

    def create
      ccv = CreditCardVerification.new(
        params[:credit_card_verification]
        .permit(:number, :exp_month, :exp_year, :full_name, :image)
        .merge(session_id: session.id, user_id: current_user.id)
      )
      ccv.save!
      flash.notice = 'Карта отправленая на проверку'
      redirect_to public_credit_cards_path
    rescue ActiveRecord::RecordInvalid
      render :new, locals: { ccv: ccv }
    end
  end
end
