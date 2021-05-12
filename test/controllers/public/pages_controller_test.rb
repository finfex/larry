# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

module Public
  class PagesControllerTest < ActionDispatch::IntegrationTest
    test 'should get index' do
      get public_pages_url
      assert_response :success
    end

    test 'should get show' do
      get public_page_url(:rules)
      assert_response :success
    end
  end
end
