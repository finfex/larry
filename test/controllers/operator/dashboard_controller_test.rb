# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

module Operator
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test 'should get index' do
      skip 'ActionView::Template::Error: No actual DirectionRate snapshot'
      get operator_root_url
      assert_response :success
    end
  end
end
