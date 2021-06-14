# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Operator
  class WalletActivitiesController < ApplicationController
    authorize_actions_for WalletActivity

    COMMANDS = {
      # 'deposit' => WalletDepositCommand,
      # 'withdrawal' => WalletWithdrawalCommand,
      'correction' => WalletCorrectionCommand
    }.freeze

    def create
      attrs = params.require(:wallet_activity)
      wallet = Wallet.find attrs.fetch(:wallet_id)
      command = COMMANDS.fetch attrs.fetch(:activity_type)

      command.call wallet: wallet, attrs: attrs.permit!, admin_user: current_admin_user

      redirect_to operator_wallet_path(wallet), notice: t('.created')
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? WalletActivity

      render 'operator/wallets/show', locals: { wallet: wallet, wallet_activity: e.record }
    end
  end
end
