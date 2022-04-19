# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Operator
  class ReservesController < ApplicationController
    authorize_actions_for Gera::PaymentSystem
    def index; end
  end
end
