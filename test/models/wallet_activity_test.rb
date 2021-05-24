# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class WalletActivityTest < ActiveSupport::TestCase
  setup do
    @wallet = Wallet.new
  end

  test 'the truth' do
    wa = WalletActivity.new wallet: @wallet
    bnding.pry
    assert true
  end
end
