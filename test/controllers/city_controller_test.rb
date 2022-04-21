require 'test_helper'

class CityControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get city_create_url
    assert_response :success
  end

  test "should get view" do
    get city_view_url
    assert_response :success
  end

  test "should get show" do
    get city_show_url
    assert_response :success
  end

  test "should get delete" do
    get city_delete_url
    assert_response :success
  end

  test "should get update" do
    get city_update_url
    assert_response :success
  end

end
