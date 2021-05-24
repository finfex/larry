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
      wallet = Wallet.find params[:wallet_activity][:wallet_id]
      command = COMMANDS.fetch(params[:wallet_activity][:activity_type])

      command.call wallet: wallet, attrs: params[:wallet_activity].permit!, admin_user: current_admin_user

      redirect_to operator_wallet_path(wallet), notice: t('.created')
    rescue ActiveRecord::RecordInvalid => e
      render 'operator/wallets/show', locals: { wallet: wallet, wallet_activity: e.record }
    end
  end
end
