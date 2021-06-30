# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class WalletsController < ApplicationController
    include ArchivableActions

    def index
      render locals: { wallets: Wallet.includes(:payment_system, :available_account, :locked_account) }
    end

    def show
      wallet = Wallet.find params[:id]
      render locals: { resource: wallet, wallet: wallet, wallet_activity: wallet.activities.build }
    end

    def new
      @resource ||= Wallet.new
      render :new, locals: { wallet: resource }
    end

    def edit
      render :edit, locals: { wallet: resource }
    end

    def update
      binding.pry
      resource.update! wallet_params
      redirect_to operator_wallet_path(resource), notice: 'Изменения приняты'
    rescue ActiveRecord::RecordInvalid
      edit
    end

    def create
      @resource = Wallet.new wallet_params
      resource.save!
      redirect_to operator_wallet_path(resource), notice: 'Кошелёк создан'
    rescue ActiveRecord::RecordInvalid
      new
    end

    private

    def success_redirect
      redirect_to operator_wallets_path
    end

    def resource
      @resource ||= Wallet.find params[:id]
    end

    def wallet_params
      params.require(:wallet).permit!
    end
  end
end
