# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class WalletTest < ActiveSupport::TestCase
  setup do
    @wallet = FactoryBot.create :wallet
  end

  def test_wallet_creation
    assert @wallet
  end
end
