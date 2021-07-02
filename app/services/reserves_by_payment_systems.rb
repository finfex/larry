# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Service to observe payment systems reservers
class ReservesByPaymentSystems
  class << self
    delegate :order_reservations, :wallet_available_balances, :final_reserves, :get_reserve_by_payment_system_id, :delta,
             to: :instance

    def instance
      RequestStore[name] ||= new
    end
  end

  # def order_reservations
  # @order_reservations ||= OrderReservation.joins(:wallet_to).group(:id_ps).sum(:amount)
  # end

  # Returns balances in cents
  def wallet_available_balances
    @wallet_available_balances ||= Wallet.alive
                                         .where(outcome_enabled: true)
                                         .joins(:available_account)
                                         .group(:payment_system_id)
                                         .sum(:amount_cents)
  end

  def final_reserves
    @final_reserves ||= build_final_reserves
  end

  def get_reserve_by_payment_system_id(id)
    final_reserves[id] || 0
  end

  def delta
    @delta ||= build_delta
  end

  private

  def ids
    @ids ||= Gera::PaymentSystem.pluck(:id)
  end

  def build_delta
    Gera::PaymentSystem.all.each_with_object({}) { |ps, a| a[ps.id] = ps.reserves_delta }
  end

  def build_final_reserves
    fr = {}

    ids.each do |id|
      value = wallet_available_balances[id].to_f
      value += delta[id].to_f
      value = 0 if value.negative?
      fr[id] = value
    end

    aggregations.each do |agregator_id, list|
      fr[agregator_id] = list.map { |id| fr[id].to_f }.sum
    end

    fr
  end

  def aggregations
    Gera::PaymentSystem.where.not(reserves_aggregator_id: nil)
                       .pluck(:reserves_aggregator_id, :id)
                       .each_with_object({}) do |k, a|
      a[k.first] ||= []
      a[k.first] << k.second
    end
  end
end
