require "test_helper"

class Operator::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get operator_dashboard_index_url
    assert_response :success
  end
end
