require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle = vehicles(:bus)
    sign_in_as users(:admin)
  end

  test "lists vehicles" do
    get vehicles_url
    assert_response :success
    assert_select "a", text: "ABC123"
  end

  test "shows vehicle" do
    get vehicle_url(@vehicle)
    assert_response :success
  end

  test "creates vehicle" do
    assert_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { plate: "new-001", driver: "Rosa", kind: "van", capacity: 12, status: "available" } }
    end
    assert_equal "NEW001", Vehicle.last.plate
    assert_redirected_to vehicle_url(Vehicle.last)
  end

  test "updates vehicle" do
    patch vehicle_url(@vehicle), params: { vehicle: { driver: "Nuevo Conductor" } }
    assert_redirected_to vehicle_url(@vehicle)
    assert_equal "Nuevo Conductor", @vehicle.reload.driver
  end

  test "rejects invalid capacity" do
    patch vehicle_url(@vehicle), params: { vehicle: { capacity: 0 } }
    assert_response :unprocessable_content
  end

  test "cannot destroy vehicle with trips" do
    assert_no_difference("Vehicle.count") { delete vehicle_url(@vehicle) }
  end

  test "destroys unused vehicle" do
    assert_difference("Vehicle.count", -1) { delete vehicle_url(vehicles(:broken)) }
    assert_redirected_to vehicles_url
  end
end
