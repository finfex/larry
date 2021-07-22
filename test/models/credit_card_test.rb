# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class CreditCardTest < ActiveSupport::TestCase
  def test_create_and_add_users
    credit_card = FactoryBot.create :credit_card
    assert credit_card.persisted?

    user = FactoryBot.create :user
    credit_card.users << user

    assert_includes credit_card.users, user
  end
end
