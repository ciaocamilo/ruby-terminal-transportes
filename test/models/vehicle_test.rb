require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  test "normalizes plate" do
    assert_equal "ABC987", Vehicle.new(plate: " abc-987 ").plate
  end

  test "requires unique plate" do
    vehicle = Vehicle.new(plate: "abc 123", driver: "Otro", capacity: 10)
    assert_not vehicle.valid?
    assert vehicle.errors.of_kind?(:plate, :taken)
  end

  test "capacity must be between 1 and 80" do
    vehicle = vehicles(:bus)
    vehicle.capacity = 0
    assert_not vehicle.valid?
    vehicle.capacity = 81
    assert_not vehicle.valid?
  end

  test "capacity cannot drop below a sold seat in scheduled trips" do
    vehicle = vehicles(:bus)
    vehicle.capacity = 1
    assert_not vehicle.valid?
    assert vehicle.errors.of_kind?(:capacity, :below_booked_seats)
  end

  test "rejects unknown kind" do
    vehicle = vehicles(:bus)
    vehicle.kind = "avion"
    assert_not vehicle.valid?
  end
end
