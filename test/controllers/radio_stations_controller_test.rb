require 'test_helper'

class RadioStationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @radio_station = radio_stations(:one)
  end

  test "should get index" do
    get radio_stations_url
    assert_response :success
  end

  test "should get new" do
    get new_radio_station_url
    assert_response :success
  end

  test "should create radio_station" do
    assert_difference('RadioStation.count') do
      post radio_stations_url, params: { radio_station: {  } }
    end

    assert_redirected_to radio_station_url(RadioStation.last)
  end

  test "should show radio_station" do
    get radio_station_url(@radio_station)
    assert_response :success
  end

  test "should get edit" do
    get edit_radio_station_url(@radio_station)
    assert_response :success
  end

  test "should update radio_station" do
    patch radio_station_url(@radio_station), params: { radio_station: {  } }
    assert_redirected_to radio_station_url(@radio_station)
  end

  test "should destroy radio_station" do
    assert_difference('RadioStation.count', -1) do
      delete radio_station_url(@radio_station)
    end

    assert_redirected_to radio_stations_url
  end
end
