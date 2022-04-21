require 'test_helper'

class VehicleControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get vehicle_show_url
    assert_response :success
  end

  test "should get create" do
    get vehicle_create_url
    assert_response :success
  end

  test "should get update" do
    get vehicle_update_url
    assert_response :success
  end

  test "should get delete" do
    get vehicle_delete_url
    assert_response :success
  end

end
