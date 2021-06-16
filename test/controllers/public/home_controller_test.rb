# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

module Public
  class HomeControllerTest < ActionDispatch::IntegrationTest
    setup do
      FactoryBot.create :direction_rate_snapshot
      FactoryBot.create :gera_payment_system
      FactoryBot.create :gera_payment_system
    end

    def test_index
      get public_root_url
      assert_response :success
    end
  end
end
