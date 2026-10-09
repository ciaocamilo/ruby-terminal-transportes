require "test_helper"

class CitiesControllerTest < ActionDispatch::IntegrationTest
  setup { @city = cities(:bogota) }

  test "requires authentication" do
    get cities_url
    assert_redirected_to new_session_url
  end

  test "seller can list and view but not manage" do
    sign_in_as users(:seller)

    get cities_url
    assert_response :success
    assert_select "td", text: "Bogotá"

    get city_url(@city)
    assert_response :success

    get new_city_url
    assert_redirected_to root_url

    assert_no_difference("City.count") do
      post cities_url, params: { city: { name: "Pasto" } }
    end
  end

  test "admin creates city" do
    sign_in_as users(:admin)

    assert_difference("City.count") do
      post cities_url, params: { city: { name: "Pasto", status: "active" } }
    end
    assert_redirected_to city_url(City.last)
  end

  test "admin gets errors on invalid city" do
    sign_in_as users(:admin)

    post cities_url, params: { city: { name: "" } }
    assert_response :unprocessable_content
    assert_select "#error_explanation"
  end

  test "admin updates city" do
    sign_in_as users(:admin)

    patch city_url(@city), params: { city: { status: "inactive" } }
    assert_redirected_to city_url(@city)
    assert @city.reload.inactive?
  end

  test "admin cannot destroy city with trips" do
    sign_in_as users(:admin)

    assert_no_difference("City.count") { delete city_url(@city) }
    assert_redirected_to city_url(@city)
  end

  test "admin destroys unused city" do
    sign_in_as users(:admin)

    assert_difference("City.count", -1) { delete city_url(cities(:tunja)) }
    assert_redirected_to cities_url
  end
end
