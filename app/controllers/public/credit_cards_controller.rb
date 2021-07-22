# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Public
  class CreditCardsController < ApplicationController
    def index
      if authenticated?
        render locals: { credit_cards: user.credit_cards, verifications: user.credit_card_verifications }
      else
        redirect_to public_credit_card_verifications_path
      end
    end
  end
end
