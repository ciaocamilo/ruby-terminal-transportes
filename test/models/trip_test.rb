require "test_helper"

class TripTest < ActiveSupport::TestCase
  def build_trip(**attributes)
    Trip.new({ origin: cities(:bogota), destination: cities(:cali), vehicle: vehicles(:bus),
               departure_at: 1.day.from_now, fare: 50_000 }.merge(attributes))
  end

  test "valid with defaults" do
    trip = build_trip
    assert trip.valid?
    assert trip.scheduled?
  end

  test "destination must differ from origin" do
    trip = build_trip(destination: cities(:bogota))
    assert_not trip.valid?
    assert trip.errors.of_kind?(:destination, :same_as_origin)
  end

  test "fare must be positive" do
    assert_not build_trip(fare: 0).valid?
  end

  test "vehicle must be available" do
    trip = build_trip(vehicle: vehicles(:broken))
    assert_not trip.valid?
    assert trip.errors.of_kind?(:vehicle, :unavailable)
  end

  test "keeps validity when its vehicle goes to maintenance later" do
    trip = trips(:bogota_medellin)
    trip.vehicle.update!(status: :maintenance)
    trip.fare = 90_000
    assert trip.valid?
  end

  test "seats left ignores cancelled bookings" do
    trip = trips(:bogota_medellin)
    assert_equal [ 1, 2 ], trip.taken_seats.sort
    assert_equal 38, trip.seats_left
  end

  test "bookable only when scheduled, in the future and with seats" do
    assert trips(:bogota_medellin).bookable?
    assert_not trips(:finished).bookable?
  end

  test "search filters by origin, destination, date and status" do
    trip = trips(:bogota_medellin)

    assert_includes Trip.search(origin_id: cities(:bogota).id), trip
    assert_not_includes Trip.search(destination_id: cities(:cali).id), trip
    assert_equal [ trip ], Trip.search(date: trip.departure_at.to_date.iso8601, destination_id: cities(:medellin).id).to_a
    assert_equal [ trips(:finished) ], Trip.search(status: "finished").to_a
  end

  test "search ignores invalid filters" do
    assert_equal Trip.count, Trip.search(date: "no-es-fecha", status: "desconocido").count
  end
end
