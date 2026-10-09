require "test_helper"

class TripsControllerTest < ActionDispatch::IntegrationTest
  setup { @trip = trips(:bogota_medellin) }

  test "seller lists and filters trips" do
    sign_in_as users(:seller)

    get trips_url, params: { origin_id: cities(:medellin).id }
    assert_response :success
    assert_select "##{ActionView::RecordIdentifier.dom_id(trips(:finished))}"
    assert_select "##{ActionView::RecordIdentifier.dom_id(@trip)}", count: 0
  end

  test "seller sees seat map but cannot create trips" do
    sign_in_as users(:seller)

    get trip_url(@trip)
    assert_response :success
    assert_select "#seat_map a", count: 38

    get new_trip_url
    assert_redirected_to root_url
  end

  test "admin creates trip" do
    sign_in_as users(:admin)

    get new_trip_url
    assert_response :success

    assert_difference("Trip.count") do
      post trips_url, params: { trip: { origin_id: cities(:cali).id, destination_id: cities(:medellin).id,
                                        vehicle_id: vehicles(:bus).id, departure_at: 2.days.from_now, fare: 70_000 } }
    end
    assert_redirected_to trip_url(Trip.last)
  end

  test "admin gets errors when origin equals destination" do
    sign_in_as users(:admin)

    post trips_url, params: { trip: { origin_id: cities(:cali).id, destination_id: cities(:cali).id,
                                      vehicle_id: vehicles(:bus).id, departure_at: 2.days.from_now, fare: 70_000 } }
    assert_response :unprocessable_content
  end

  test "admin updates trip" do
    sign_in_as users(:admin)

    patch trip_url(@trip), params: { trip: { status: "in_progress" } }
    assert_redirected_to trip_url(@trip)
    assert @trip.reload.in_progress?
  end

  test "admin cannot destroy trip with bookings" do
    sign_in_as users(:admin)

    assert_no_difference("Trip.count") { delete trip_url(@trip) }
  end

  test "admin destroys trip without bookings" do
    sign_in_as users(:admin)

    assert_difference("Trip.count", -1) { delete trip_url(trips(:bogota_cali_van)) }
    assert_redirected_to trips_url
  end
end
