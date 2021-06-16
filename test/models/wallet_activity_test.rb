# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class WalletActivityTest < ActiveSupport::TestCase
  setup do
    @wallet = FactoryBot.create :wallet
  end

  def test_save_wallet_activity
    assert WalletActivity.new wallet: @wallet
  end
end
