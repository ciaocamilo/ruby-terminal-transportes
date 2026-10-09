require "test_helper"

class CityTest < ActiveSupport::TestCase
  test "requires a unique name ignoring case" do
    city = City.new(name: "  bogotá ")
    assert_not city.valid?
    assert city.errors.of_kind?(:name, :taken)
  end

  test "normalizes whitespace in name" do
    assert_equal "Santa Marta", City.new(name: "  Santa   Marta ").name
  end

  test "cannot be destroyed while it has trips" do
    city = cities(:bogota)
    assert_not city.destroy
    assert City.exists?(city.id)
  end
end
