# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class CreditCardVerificationTest < ActiveSupport::TestCase
  def test_linking_card
    user = FactoryBot.create(:user)
    credit_card_verification = FactoryBot.create :credit_card_verification, user: user
    credit_card_verification.accept!
    credit_card_verification.save!
    assert credit_card_verification.credit_card.persisted?
    assert_includes credit_card_verification.credit_card.users, user
  end
end
