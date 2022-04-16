# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Operator
  class WalletActivitiesController < ApplicationController
    authorize_actions_for WalletActivity

    helper_method :resource

    attr_reader :resource

    COMMANDS = {
      # 'deposit' => WalletDepositCommand,
      # 'withdrawal' => WalletWithdrawalCommand,
      'correction' => WalletCorrectionCommand
    }.freeze

    def show
      wa = WalletActivity.find params[:id]
      @resource = wa.wallet
      redirect_to operator_wallet_path(wa.wallet, anchor: 'wallet_activity_' + wa.id.to_s)
    end

    def create
      attrs = params.require(:wallet_activity)
      wallet = Wallet.find attrs.fetch(:wallet_id)
      @resource = wallet
      command = COMMANDS.fetch attrs.fetch(:activity_type)

      command.call(
        wallet: wallet,
        amount: attrs.fetch(:amount).to_money(wallet.currency),
        details: attrs.fetch(:details),
        admin_user: current_admin_user
      )

      redirect_to operator_wallet_path(wallet), notice: t('.created')
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? WalletActivity

      render 'operator/wallets/show', locals: { wallet: wallet, resource: wallet, wallet_activity: e.record }
    end
  end
end
