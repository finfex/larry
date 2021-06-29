# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

module Public
  class PagesControllerTest < ActionDispatch::IntegrationTest
    def test_show
      get public_page_url(:rules)
      assert_response :success
    end
  end
end
