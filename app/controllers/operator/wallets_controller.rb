# frozen_string_literal: true

module Operator
  class WalletsController < ApplicationController
    def index
      render locals: { wallets: Wallet.includes(:payment_system, :available_account, :locked_account) }
    end
  end
end
