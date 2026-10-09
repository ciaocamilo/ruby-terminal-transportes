require "test_helper"

class BookingTest < ActiveSupport::TestCase
  def build_booking(**attributes)
    Booking.new({ trip: trips(:bogota_medellin), user: users(:seller), passenger_name: "Juan Gil",
                  passenger_document: "123", seat_number: 10 }.merge(attributes))
  end

  test "valid booking" do
    assert build_booking.valid?
  end

  test "seat cannot be sold twice" do
    booking = build_booking(seat_number: 1)
    assert_not booking.valid?
    assert booking.errors.of_kind?(:seat_number, :taken)
  end

  test "seat from a cancelled booking can be sold again" do
    assert build_booking(seat_number: 3).valid?
  end

  test "seat must be within vehicle capacity" do
    booking = build_booking(seat_number: 41)
    assert_not booking.valid?
    assert booking.errors.of_kind?(:seat_number, :exceeds_capacity)
  end

  test "cannot book a finished trip" do
    booking = build_booking(trip: trips(:finished))
    assert_not booking.valid?
    assert booking.errors.of_kind?(:trip, :not_bookable)
  end

  test "cannot book a full trip" do
    trip = trips(:bogota_cali_van)
    build_booking(trip:, seat_number: 1).save!
    build_booking(trip:, seat_number: 2).save!

    assert_not build_booking(trip:, seat_number: 1).valid?
    assert_not trip.bookable?
  end

  test "cannot be created already cancelled" do
    assert_not build_booking(status: :cancelled).valid?
  end

  test "cancel frees the seat" do
    bookings(:paid_seat_one).cancel!
    assert_not_includes trips(:bogota_medellin).taken_seats, 1
  end
end
