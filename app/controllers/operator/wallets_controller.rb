# frozen_string_literal: true

module Operator
  class WalletsController < ApplicationController
    def index
      render locals: { wallets: Wallet.all }
    end
  end
end
