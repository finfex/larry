# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class CreditCardVerificationsController < ApplicationController
    helper_method :current_state

    before_action only: [:index] do
      redirect_to operator_credit_card_verifications_path(q: { by_state: :pending }) unless params.key? :q
    end

    def show
      render locals: { credit_card_verification: credit_card_verification }
    end

    def start
      credit_card_verification.process! current_admin_user
      redirect_to operator_credit_card_verification_path(credit_card_verification), notice: 'Притяна в обработку'
    end

    def accept
      credit_card_verification.accept! current_admin_user
      flash.notice = 'Карта принята'
      if credit_card_verification.order.present?
        redirect_to operator_order_path(credit_card_verification.order)
      else
        redirect_to operator_credit_card_verifications_path
      end
    end

    def reject
      credit_card_verification.reject! current_admin_user
      redirect_to operator_credit_card_verifications_path, notice: 'Карта отклонена'
    end

    private

    def current_state
      q_params['by_state']
    end

    def credit_card_verification
      @credit_card_verification ||= CreditCardVerification.find params[:id]
    end
  end
end
