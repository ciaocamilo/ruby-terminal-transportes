require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trip = trips(:bogota_medellin)
    sign_in_as users(:seller)
  end

  test "new preselects seat" do
    get new_trip_booking_url(@trip, seat_number: 5)
    assert_response :success
    assert_select "select#booking_seat_number option[selected][value='5']"
  end

  test "sells a ticket" do
    assert_difference("Booking.count") do
      post trip_bookings_url(@trip), params: { booking: { passenger_name: "Juan Gil", passenger_document: "123", seat_number: 5, status: "paid" } }
    end
    booking = Booking.last
    assert_equal users(:seller), booking.user
    assert_redirected_to trip_booking_url(@trip, booking)
  end

  test "rejects an occupied seat" do
    assert_no_difference("Booking.count") do
      post trip_bookings_url(@trip), params: { booking: { passenger_name: "Juan Gil", passenger_document: "123", seat_number: 1 } }
    end
    assert_response :unprocessable_content
  end

  test "shows ticket" do
    get trip_booking_url(@trip, bookings(:paid_seat_one))
    assert_response :success
    assert_select "#ticket", text: /María López/
  end

  test "seller pays own reservation" do
    booking = bookings(:reserved_seat_two)
    patch pay_trip_booking_url(@trip, booking)
    assert booking.reload.paid?
  end

  test "seller cancels own booking" do
    booking = bookings(:paid_seat_one)
    patch cancel_trip_booking_url(@trip, booking)
    assert_redirected_to trip_url(@trip)
    assert booking.reload.cancelled?
  end

  test "another seller cannot cancel the booking" do
    delete session_url
    sign_in_as users(:other_seller)

    booking = bookings(:paid_seat_one)
    patch cancel_trip_booking_url(@trip, booking)
    assert booking.reload.paid?
  end

  test "admin can cancel any booking" do
    delete session_url
    sign_in_as users(:admin)

    booking = bookings(:paid_seat_one)
    patch cancel_trip_booking_url(@trip, booking)
    assert booking.reload.cancelled?
  end
end
