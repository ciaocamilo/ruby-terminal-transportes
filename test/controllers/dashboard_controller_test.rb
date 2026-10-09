require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects guests to sign in" do
    get root_url
    assert_redirected_to new_session_url
  end

  test "shows upcoming trips" do
    sign_in_as users(:seller)

    get root_url
    assert_response :success
    assert_select "##{ActionView::RecordIdentifier.dom_id(trips(:bogota_medellin))}"
    assert_select "##{ActionView::RecordIdentifier.dom_id(trips(:finished))}", count: 0
  end
end
