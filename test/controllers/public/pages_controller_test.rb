require "test_helper"

class Public::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_pages_index_url
    assert_response :success
  end

  test "should get show" do
    get public_pages_show_url
    assert_response :success
  end
end
