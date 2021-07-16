# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Public
  class CreditCardsController < ApplicationController
    before_action :unauthenticated, unless: :authenticated?
    def index
      render locals: { credit_cards: user.credit_cards, verifications: user.credit_card_verifications }
    end
  end
end
