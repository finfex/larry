# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class ApplicationController < ApplicationController
    layout 'public'

    helper_method :final_reserves, :income_payment_systems, :outcome_payment_systems

    private

    def income_payment_systems
      Gera::PaymentSystem.alive.available.enabled.where(income_enabled: true).ordered
    end

    def outcome_payment_systems
      Gera::PaymentSystem.alive.available.enabled.where(outcome_enabled: true).ordered
    end

    def final_reserves
      @final_reserves ||= ReservesByPaymentSystems.new.final_reserves
    end
  end
end
