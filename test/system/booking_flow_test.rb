require "application_system_test_case"

class BookingFlowTest < ApplicationSystemTestCase
  test "seller searches a trip and sells a seat" do
    sign_in_as users(:seller)

    click_on "Viajes"
    select "Medellín", from: "Destino"
    click_on "Buscar"
    click_on I18n.l(trips(:bogota_medellin).departure_at, format: :short)

    within("#seat_map") { find("a", exact_text: "5").click }
    fill_in "Nombre del pasajero", with: "Juan Gil"
    fill_in "Documento del pasajero", with: "123456"
    click_on "Vender"

    assert_text "Pasaje vendido."
    within("#ticket") do
      assert_text "Juan Gil"
      assert_text "Bogotá → Medellín"
    end
  end

  test "admin creates a city" do
    sign_in_as users(:admin)

    click_on "Ciudades"
    click_on "Nueva ciudad"
    fill_in "Nombre", with: "Pasto"
    click_on "Guardar"

    assert_text "Ciudad creada."
  end
end
