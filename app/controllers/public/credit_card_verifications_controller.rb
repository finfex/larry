# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Public
  class CreditCardVerificationsController < ApplicationController
    def new
      render locals: { ccv: CreditCardVerification.new(order_id: params[:order_id]) }
    end

    def index
      if authenticated?
        redirect_to public_credit_cards_path
      else
        render locals: { verifications: CreditCardVerification.where(session_id: session.id.to_s).order('created_at desc') }
      end
    end

    def create
      ccv = CreditCardVerification.new(
        params[:credit_card_verification]
        .permit(:order_id, :number, :exp_month, :exp_year, :full_name, :image)
        .merge(session_id: session.id.to_s, user_id: current_user.try(:id))
      )
      ccv.save!
      flash.notice = 'Карта отправленая на проверку'
      if authenticated?
        redirect_to public_credit_cards_path
      else
        redirect_to public_credit_card_verifications_path
      end
    rescue ActiveRecord::RecordInvalid
      render :new, locals: { ccv: ccv }
    end
  end
end
