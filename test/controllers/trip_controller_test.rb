require 'test_helper'

class TripControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get trip_show_url
    assert_response :success
  end

  test "should get create" do
    get trip_create_url
    assert_response :success
  end

  test "should get update" do
    get trip_update_url
    assert_response :success
  end

  test "should get delete" do
    get trip_delete_url
    assert_response :success
  end

end
