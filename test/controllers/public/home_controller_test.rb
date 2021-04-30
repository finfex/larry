# frozen_string_literal: true

require 'test_helper'

module Public
  class HomeControllerTest < ActionDispatch::IntegrationTest
    test 'should get index' do
      get public_root_url
      assert_response :success
    end
  end
end
